-- Copyright 2011-15 Paul Kulchenko, ZeroBrane LLC
-- authors: Luxinia Dev (Eike Decker & Christoph Kubisch)
-- Lomtik Software (J. Winwood & John Labenski)
---------------------------------------------------------

local ide = ide
local unpack = table.unpack or unpack

-- Pick some reasonable fixed width fonts to use for the editor
local function setFont(style, config)
  return wx.wxFont(config.fontsize or 10, wx.wxFONTFAMILY_MODERN, style,
    wx.wxFONTWEIGHT_NORMAL, false, config.fontname or "",
    config.fontencoding or wx.wxFONTENCODING_DEFAULT)
end
ide.font.eNormal = setFont(wx.wxFONTSTYLE_NORMAL, ide.config.editor)
ide.font.eItalic = setFont(wx.wxFONTSTYLE_ITALIC, ide.config.editor)

ide.font.oNormal = setFont(wx.wxFONTSTYLE_NORMAL, ide.config.outputshell)
ide.font.oItalic = setFont(wx.wxFONTSTYLE_ITALIC, ide.config.outputshell)

-- treeCtrl font requires slightly different handling
do local gui, config = wx.wxTreeCtrl():GetFont(), ide.config.filetree
  if config.fontsize then gui:SetPointSize(config.fontsize) end
  if config.fontname then gui:SetFaceName(config.fontname) end
  ide.font.fNormal = gui
end

-- ----------------------------------------------------------------------------
-- Create the wxFrame
-- ----------------------------------------------------------------------------
local function createFrame()
  local frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, GetIDEString("editor"),
    wx.wxDefaultPosition, wx.wxSize(1100, 700))
  frame:Center()

  -- update best size of the toolbar after resizing
  frame:Connect(wx.wxEVT_SIZE, function(event)
      local mgr = ide:GetUIManager()
      local toolbar = mgr:GetPane("toolbar")
      if toolbar and toolbar:IsOk() then
        toolbar:BestSize(event:GetSize():GetWidth(), ide:GetToolBar():GetClientSize():GetHeight())
        mgr:Update()
      end
    end)

  local menuBar = wx.wxMenuBar()
  local statusBar = frame:CreateStatusBar(7)
  local section_width = statusBar:GetTextExtent("OVRW")
  statusBar:SetStatusStyles({wx.wxSB_FLAT, wx.wxSB_FLAT, wx.wxSB_FLAT,
      wx.wxSB_FLAT, wx.wxSB_FLAT, wx.wxSB_FLAT, wx.wxSB_FLAT})
  statusBar:SetStatusWidths(
    {-1, section_width*6, section_width, section_width, section_width*5, section_width*4, section_width*10})
  statusBar:SetStatusText(GetIDEString("statuswelcome"))
  statusBar:Connect(wx.wxEVT_LEFT_DOWN, function (event)
      local rect = wx.wxRect()
      statusBar:GetFieldRect(4, rect)
      if rect:Contains(event:GetPosition()) then -- click on the interpreter
        local menuitem = ide:FindMenuItem(ID.INTERPRETER)
        if menuitem then
          local menu = ide:CloneMenu(menuitem:GetSubMenu())
          if menu then statusBar:PopupMenu(menu) end
        end
      end
    end)

  local mgr = wxaui.wxAuiManager()
  mgr:SetManagedWindow(frame)
  -- allow the panes to be larger than the defalt 1/3 of the main window size
  mgr:SetDockSizeConstraint(0.8,0.8)

  frame.menuBar = menuBar
  frame.statusBar = statusBar
  frame.uimgr = mgr

  return frame
end

local function SCinB(id) -- shortcut in brackets
  local shortcut = KSC(id):gsub("\t","")
  return shortcut and #shortcut > 0 and (" ("..shortcut..")") or ""
end

local function menuDropDownPosition(event)
  local tb = event:GetEventObject():DynamicCast('wxAuiToolBar')
  local rect = tb:GetToolRect(event:GetId())
  return ide.frame:ScreenToClient(tb:ClientToScreen(rect:GetBottomLeft()))
end

local function tbIconSize()
  -- use large icons by default on OSX and on large screens
  local iconsize = (tonumber(ide.config.toolbar and ide.config.toolbar.iconsize)
    or ((ide.osname == 'Macintosh' or wx.wxGetClientDisplayRect():GetWidth() >= 1500) and 24 or 16))
  if iconsize ~= 24 then iconsize = 16 end
  return iconsize
end

local function createToolBar(frame)
  local toolBar = wxaui.wxAuiToolBar(frame, wx.wxID_ANY, wx.wxDefaultPosition, wx.wxDefaultSize,
    wxaui.wxAUI_TB_PLAIN_BACKGROUND)

  -- there are two sets of icons: use 24 on OSX and 16 on others.
  local iconsize = tbIconSize()
  local toolBmpSize = wx.wxSize(iconsize, iconsize)
  local icons, prev = ide.config.toolbar.icons
  for _, id in ipairs(icons) do
    if icons[id] ~= false then -- skip explicitly disabled icons
      if id == ID_SEPARATOR then
        -- make sure that there are no two separators next to each other;
        -- this may happen when some of the icons are disabled.
        if prev ~= ID_SEPARATOR then toolBar:AddSeparator() end
      else
        local iconmap = ide.config.toolbar.iconmap[id]
        if iconmap then
          local icon, description = unpack(iconmap)
          local isbitmap = type(icon) == "userdata" and icon:GetClassInfo():GetClassName() == "wxBitmap"
          local bitmap = isbitmap and icon or ide:GetBitmap(icon, "TOOLBAR", toolBmpSize)
          toolBar:AddTool(id, "", bitmap, (TR)(description)..SCinB(id))
        end
      end
      prev = id
    end
  end

  -- @My [[
  local choices = {}
  local comboBox = wx.wxComboBox(toolBar, ID_FUNCLIST, "",
    wx.wxDefaultPosition, wx.wxSize(300,toolBar:GetSize():GetHeight()), choices)
    comboBox:Connect(ID_FUNCLIST, wx.wxEVT_COMMAND_COMBOBOX_SELECTED,
    function(event)
      GotoFunctionDefineByName(GetEditor(), comboBox:GetValue());
    end
  )
  toolBar:AddControl(comboBox, "Current File Function List")
  toolBar.functionlist = comboBox
  --]]

  toolBar:SetToolDropDown(ID_OPEN, true)
  toolBar:Connect(ID_OPEN, wxaui.wxEVT_COMMAND_AUITOOLBAR_TOOL_DROPDOWN, function(event)
      if event:IsDropDownClicked() then
        local menu = wx.wxMenu({})
        FileRecentListUpdate(menu)
        toolBar:PopupMenu(menu, menuDropDownPosition(event))
      else
        event:Skip()
      end
    end)

  toolBar:SetToolDropDown(ID_PROJECTDIRCHOOSE, true)
  toolBar:Connect(ID_PROJECTDIRCHOOSE, wxaui.wxEVT_COMMAND_AUITOOLBAR_TOOL_DROPDOWN, function(event)
      if event:IsDropDownClicked() then
        local menu = wx.wxMenu({})
        FileTreeProjectListUpdate(menu, 0)
        toolBar:PopupMenu(menu, menuDropDownPosition(event))
      else
        event:Skip()
      end
    end)

  toolBar:GetArtProvider():SetElementSize(wxaui.wxAUI_TBART_GRIPPER_SIZE, 0)
  toolBar:Realize()

  frame.toolBar = toolBar
  return toolBar
end

local function getTabWindow(event, nb)
  local tabctrl = event:GetEventObject():DynamicCast("wxAuiTabCtrl")
  local idx = event:GetSelection() -- index within the current tab ctrl
  return idx ~= wx.wxNOT_FOUND and nb:GetPageIndex(tabctrl:GetPage(idx).window) or wx.wxNOT_FOUND, tabctrl
end


local function isPreview(win)
  return ide.findReplace ~= nil and ide.findReplace:IsPreview(win)
end

function changePageHistory(ed)
	ed.pageHistoryIndex = getHistoryIndex();
end

function getNavigationPage(index, forward)
	local pos = -1;
	local pages = {}
	local notebook = ide.frame.notebook;
	for k=0,notebook:GetPageCount() do
		table.insert(pages, GetEditor(k));
	end
	table.sort(pages, function(a,b)
		return a.pageHistoryIndex > b.pageHistoryIndex
	end
	)

	if #pages > 6 then
		for k=#pages, 7,-1 do
			table.remove(pages, k);
		end
	end

	for k=1,#pages do
		if notebook:GetPageIndex(pages[k]) == index then
			pos = k;
			break;
		end
	end

	if pos == -1 then
		return nil;
	end

	local edPage=nil
	if forward then
		if pos == #pages then
			edPage = pages[1];
		else
			edPage = pages[pos+1];
		end
	else
		if pos == 1 then
			edPage = pages[#pages];
		else
			edPage = pages[pos-1];
		end
	end

	return edPage;
end

function getHistoryIndex()
	local maxIndex = 0;
	local notebook = ide.frame.notebook; 
	if notebook then
		local s, e = 1, notebook:GetPageCount()
		for k=s,e do
			local ed = GetEditor(k-1)
			if ed.pageHistoryIndex > maxIndex then
				maxIndex = ed.pageHistoryIndex;
			end
		end
	end

	return maxIndex+1;
end

local function createNotebook(frame)
  -- notebook for editors
  local notebook = wxaui.wxAuiNotebook(frame, wx.wxID_ANY,
    wx.wxDefaultPosition, wx.wxDefaultSize,
    wxaui.wxAUI_NB_DEFAULT_STYLE + wxaui.wxAUI_NB_TAB_EXTERNAL_MOVE
    + wxaui.wxAUI_NB_WINDOWLIST_BUTTON + wx.wxNO_BORDER)

  notebook:Connect(wx.wxEVT_NAVIGATION_KEY,
    function (event)
      event:Skip(false);
	  if notebook:GetPageCount() < 2 then
		return
	  end

	  frame.enableHistory = false;
	  local ed = getNavigationPage(notebook:GetSelection(), event:GetDirection());
	  if ed ~= nil then
		notebook:SetSelection(notebook:GetPageIndex(ed));
	  end
	  frame.enableHistory = true;
    end)

  -- wxEVT_SET_FOCUS could be used, but it only works on Windows with wx2.9.5+
  notebook:Connect(wxaui.wxEVT_COMMAND_AUINOTEBOOK_PAGE_CHANGED,
    function (event)
      local ed = GetEditor(notebook:GetSelection())
      local doc = ed and ide:GetDocument(ed)

      -- skip activation when any of the following is true:
      -- (1) there is no document yet, the editor tab was just added,
      -- so no changes needed as there will be a proper later call;
      -- (2) the page change event was triggered after a tab is closed;
      -- (3) on OSX from AddPage event when changing from the last tab
      -- (this is to work around a duplicate event generated in this case
      -- that first activates the added tab and then some other tab (2.9.5)).

      local double = (ide.osname == 'Macintosh'
        and event:GetOldSelection() == notebook:GetPageCount()
        and debug:traceback():find("'AddPage'"))

      if doc and event:GetOldSelection() ~= wx.wxNOT_FOUND and not double then
        SetEditorSelection(notebook:GetSelection())
      end
      if frame.enableHistory and notebook then
        changePageHistory(GetEditor(notebook:GetSelection()));
      end
    end)

  notebook:Connect(wxaui.wxEVT_COMMAND_AUINOTEBOOK_PAGE_CLOSE,
    function (event)
      local idx = event:GetSelection()
      if idx ~= wx.wxNOT_FOUND then ClosePage(idx) end
      event:Veto() -- don't propagate the event as the page is already closed
    end)

  notebook:Connect(wxaui.wxEVT_COMMAND_AUINOTEBOOK_BG_DCLICK,
    function (event)
      -- as this event can be on different tab controls,
      -- need to find the control to add the page to
      local tabctrl = event:GetEventObject():DynamicCast("wxAuiTabCtrl")
      -- check if the active page is in the current control
      local active = tabctrl:GetActivePage()
      if (active >= 0 and tabctrl:GetPage(active).window
        ~= notebook:GetPage(notebook:GetSelection())) then
        -- if not, need to activate the control that was clicked on;
        -- find the last window and switch to it (assuming there is always one)
        assert(tabctrl:GetPageCount() >= 1, "Expected at least one page in a notebook tab control.")
        local lastwin = tabctrl:GetPage(tabctrl:GetPageCount()-1).window
        notebook:SetSelection(notebook:GetPageIndex(lastwin))
      end
      NewFile()
    end)

  -- tabs can be dragged around which may change their indexes;
  -- when this happens stored indexes need to be updated to reflect the change.
  -- there is DRAG_DONE event that I'd prefer to use, but it
  -- doesn't fire for some reason using wxwidgets 2.9.5 (tested on Windows).
  if ide.wxver >= "2.9.5" then
    notebook:Connect(wxaui.wxEVT_COMMAND_AUINOTEBOOK_END_DRAG,
      function (event)
        for page = 0, notebook:GetPageCount()-1 do
          local editor = GetEditor(page)
          if editor then ide.openDocuments[editor:GetId()].index = page end
        end

        local selection = getTabWindow(event, notebook)
        if selection == wx.wxNOT_FOUND then return end
        -- set the selection on the dragged tab to reset its state
        -- workaround for wxwidgets issue http://trac.wxwidgets.org/ticket/15071
        notebook:SetSelection(selection)
        -- select the content of the tab after drag is done
        SetEditorSelection(selection)
        event:Skip()
      end)
  end

  local selection
  notebook:Connect(wxaui.wxEVT_COMMAND_AUINOTEBOOK_TAB_RIGHT_UP,
    function (event)
      -- event:GetSelection() returns the index *inside the current tab*;
      -- for split notebooks, this may not be the same as the index
      -- in the notebook we are interested in here
      local idx = event:GetSelection()
      if idx == wx.wxNOT_FOUND then return end
      local tabctrl = event:GetEventObject():DynamicCast("wxAuiTabCtrl")

      -- save tab index the event is for
      selection = notebook:GetPageIndex(tabctrl:GetPage(idx).window)

      local menu = ide:MakeMenu {
        { ID_CLOSE, TR("&Close Page") },
        { ID_CLOSEALL, TR("Close A&ll Pages") },
        { ID_CLOSEOTHER, TR("Close &Other Pages") },
        { ID_CLOSESEARCHRESULTS, TR("Close Search Results Pages") },
        { },
        { ID_SAVE, TR("&Save") },
        { ID_SAVEAS, TR("Save &As...") },
        { },
        { ID_COPYFULLPATH, TR("Copy Full Path") },
        { ID_SHOWLOCATION, TR("Show Location") },
      }

      PackageEventHandle("onMenuEditorTab", menu, notebook, event, selection)

      notebook:PopupMenu(menu)
    end)

  local function IfAtLeastOneTab(event) event:Enable(notebook:GetPageCount() > 0) end

  notebook:Connect(ID_SAVE, wx.wxEVT_COMMAND_MENU_SELECTED, function()
      ide:GetDocument(GetEditor(selection)):Save()
    end)
  notebook:Connect(ID_SAVE, wx.wxEVT_UPDATE_UI, function(event)
      local doc = ide:GetDocument(GetEditor(selection))
      event:Enable(doc:IsModified() or doc:IsNew())
    end)
  notebook:Connect(ID_SAVEAS, wx.wxEVT_COMMAND_MENU_SELECTED, function()
      SaveFileAs(GetEditor(selection))
    end)
  notebook:Connect(ID_SAVEAS, wx.wxEVT_UPDATE_UI, IfAtLeastOneTab)

  -- the following three methods require handling of closing in the idle event,
  -- because of wxwidgets issue that causes crash on OSX when the last page is closed
  -- (http://trac.wxwidgets.org/ticket/15417)
  notebook:Connect(ID_CLOSE, wx.wxEVT_COMMAND_MENU_SELECTED, function()
      ide:DoWhenIdle(function() ClosePage(selection) end)
    end)
  notebook:Connect(ID_CLOSEALL, wx.wxEVT_COMMAND_MENU_SELECTED, function()
      ide:DoWhenIdle(function() CloseAllPagesExcept(nil) end)
    end)
  notebook:Connect(ID_CLOSEOTHER, wx.wxEVT_COMMAND_MENU_SELECTED, function()
      ide:DoWhenIdle(function() CloseAllPagesExcept(selection) end)
    end)
  notebook:Connect(ID_CLOSESEARCHRESULTS, wx.wxEVT_COMMAND_MENU_SELECTED, function()
      ide:DoWhenIdle(function()
          for p = notebook:GetPageCount()-1, 0, -1 do
            if isPreview(notebook:GetPage(p)) then ClosePage(p) end
          end
        end)
    end)
  notebook:Connect(ID_CLOSE, wx.wxEVT_UPDATE_UI, IfAtLeastOneTab)
  notebook:Connect(ID_CLOSEALL, wx.wxEVT_UPDATE_UI, IfAtLeastOneTab)
  notebook:Connect(ID_CLOSEOTHER, wx.wxEVT_UPDATE_UI, function(event)
      event:Enable(notebook:GetPageCount() > 1)
    end)
  notebook:Connect(ID_CLOSESEARCHRESULTS, wx.wxEVT_UPDATE_UI, function(event)
      local ispreview = false
      for p = 0, notebook:GetPageCount()-1 do
        ispreview = ispreview or isPreview(notebook:GetPage(p))
      end
      event:Enable(ispreview)
    end)

  notebook:Connect(ID_SHOWLOCATION, wx.wxEVT_COMMAND_MENU_SELECTED, function()
      ShowLocation(ide:GetDocument(GetEditor(selection)):GetFilePath())
    end)
  notebook:Connect(ID_SHOWLOCATION, wx.wxEVT_UPDATE_UI, IfAtLeastOneTab)

  notebook:Connect(ID_COPYFULLPATH, wx.wxEVT_COMMAND_MENU_SELECTED, function()
      ide:CopyToClipboard(ide:GetDocument(GetEditor(selection)):GetFilePath())
    end)

  frame.notebook = notebook
  frame.enableHistory = true;

  return notebook
end

local function addDND(notebook)
  -- this handler allows dragging tabs into this notebook
  notebook:Connect(wxaui.wxEVT_COMMAND_AUINOTEBOOK_ALLOW_DND,
    function (event)
      local notebookfrom = event:GetDragSource()
      if notebookfrom ~= ide.frame.notebook then
        -- disable cross-notebook movement of specific tabs
        local idx = event:GetSelection()
        if idx == wx.wxNOT_FOUND then return end
        local win = notebookfrom:GetPage(idx)
        if not win then return end
        local winid = win:GetId()
        if winid == ide:GetOutput():GetId()
        or winid == ide:GetConsole():GetId()
        or winid == ide:GetProjectTree():GetId()
        or isPreview(win) -- search results preview
        then return end

        local mgr = ide.frame.uimgr
        local pane = mgr:GetPane(notebookfrom)
        if not pane:IsOk() then return end -- not a managed window
        if pane:IsFloating() then
          notebookfrom:GetParent():Hide()
        else
          pane:Hide()
          mgr:Update()
        end
        mgr:DetachPane(notebookfrom)

        -- this is a workaround for wxwidgets bug (2.9.5+) that combines
        -- content from two windows when tab is dragged over an active tab.
        local mouse = wx.wxGetMouseState()
        local mouseatpoint = wx.wxPoint(mouse:GetX(), mouse:GetY())
        local ok, tabs = pcall(function() return wx.wxFindWindowAtPoint(mouseatpoint):DynamicCast("wxAuiTabCtrl") end)
        if ok then tabs:SetNoneActive() end

        event:Allow()
      end
    end)

  -- these handlers allow dragging tabs out of this notebook.
  -- I couldn't find a good way to stop dragging event as it's not known
  -- where the event is going to end when it's started, so we manipulate
  -- the flag that allows splits and disable it when needed.
  -- It is then enabled in BEGIN_DRAG event.
  notebook:Connect(wxaui.wxEVT_COMMAND_AUINOTEBOOK_BEGIN_DRAG,
    function (event)
      event:Skip()

      -- allow dragging if it was disabled earlier
      local flags = notebook:GetWindowStyleFlag()
      if bit.band(flags, wxaui.wxAUI_NB_TAB_SPLIT) == 0 then
        notebook:SetWindowStyleFlag(flags + wxaui.wxAUI_NB_TAB_SPLIT)
      end
    end)

  -- there is currently no support in wxAuiNotebook for dragging tabs out.
  -- This is implemented as removing a tab that was dragged out and
  -- recreating it with the right control. This is complicated by the fact
  -- that tabs can be split, so if the destination is withing the area where
  -- splits happen, the tab is not removed.
  notebook:Connect(wxaui.wxEVT_COMMAND_AUINOTEBOOK_END_DRAG,
    function (event)
      event:Skip()

      local mgr = ide.frame.uimgr
      local win = mgr:GetPane(notebook).window
      local x = win:GetScreenPosition():GetX()
      local y = win:GetScreenPosition():GetY()
      local w, h = win:GetSize():GetWidth(), win:GetSize():GetHeight()

      local selection, tabctrl = getTabWindow(event, notebook)
      if selection == wx.wxNOT_FOUND then return end

      local mouse = wx.wxGetMouseState()
      local mx, my = mouse:GetX(), mouse:GetY()
      if mx < x or mx > x + w or my < y or my > y + h then
        -- disallow split as the target is outside the notebook
        local flags = notebook:GetWindowStyleFlag()
        if bit.band(flags, wxaui.wxAUI_NB_TAB_SPLIT) ~= 0 then
          notebook:SetWindowStyleFlag(flags - wxaui.wxAUI_NB_TAB_SPLIT)
        end

        -- don't allow dragging out single tabs from tab ctrl
        -- as wxwidgets doesn't like removing pages from split notebooks.
        if tabctrl:GetPageCount() == 1 then return end

        local label = notebook:GetPageText(selection)
        local pane = ide:RestorePanelByLabel(label)
        if pane then
          pane:FloatingPosition(mx-10, my-10)
          pane:Show()
          notebook:RemovePage(selection)
          mgr:Update()
          return
        end
      end

      -- set the selection on the dragged tab to reset its state
      -- workaround for wxwidgets issue http://trac.wxwidgets.org/ticket/15071
      notebook:SetSelection(selection)
      -- set focus on the content of the selected tab
      notebook:GetPage(selection):SetFocus()
    end)
end

local function createBottomNotebook(frame)
  -- bottomnotebook (errorlog,shellbox)
  local bottomnotebook = wxaui.wxAuiNotebook(frame, wx.wxID_ANY,
    wx.wxDefaultPosition, wx.wxDefaultSize,
    wxaui.wxAUI_NB_DEFAULT_STYLE + wxaui.wxAUI_NB_TAB_EXTERNAL_MOVE
    - wxaui.wxAUI_NB_CLOSE_ON_ACTIVE_TAB + wx.wxNO_BORDER)

  addDND(bottomnotebook)

  bottomnotebook:Connect(wxaui.wxEVT_COMMAND_AUINOTEBOOK_PAGE_CHANGED,
    function (event)
      local nb = event:GetEventObject():DynamicCast("wxAuiNotebook")
      -- set focus on the new page
      local idx = event:GetSelection()
      if idx == wx.wxNOT_FOUND then return end
      nb:GetPage(idx):SetFocus()

      local preview = isPreview(nb:GetPage(nb:GetSelection()))
      local flags = nb:GetWindowStyleFlag()
      if preview and bit.band(flags, wxaui.wxAUI_NB_CLOSE_ON_ACTIVE_TAB) == 0 then
        nb:SetWindowStyleFlag(flags + wxaui.wxAUI_NB_CLOSE_ON_ACTIVE_TAB)
      elseif not preview and bit.band(flags, wxaui.wxAUI_NB_CLOSE_ON_ACTIVE_TAB) ~= 0 then
        nb:SetWindowStyleFlag(flags - wxaui.wxAUI_NB_CLOSE_ON_ACTIVE_TAB)
      end
    end)

  -- disallow tabs closing
  bottomnotebook:Connect(wxaui.wxEVT_COMMAND_AUINOTEBOOK_PAGE_CLOSE,
    function (event)
      local nb = event:GetEventObject():DynamicCast("wxAuiNotebook")
      if isPreview(nb:GetPage(nb:GetSelection())) then
        event:Skip()
      else
        event:Veto()
      end
    end)

  local selection
  bottomnotebook:Connect(wxaui.wxEVT_COMMAND_AUINOTEBOOK_TAB_RIGHT_UP,
    function (event)
      -- event:GetSelection() returns the index *inside the current tab*;
      -- for split notebooks, this may not be the same as the index
      -- in the notebook we are interested in here
      local idx = event:GetSelection()
      if idx == wx.wxNOT_FOUND then return end
      local tabctrl = event:GetEventObject():DynamicCast("wxAuiTabCtrl")

      -- save tab index the event is for
      selection = bottomnotebook:GetPageIndex(tabctrl:GetPage(idx).window)

      local menu = ide:MakeMenu {
        { ID_CLOSE, TR("&Close Page") },
        { ID_CLOSESEARCHRESULTS, TR("Close Search Results Pages") },
      }

      PackageEventHandle("onMenuOutputTab", menu, bottomnotebook, event, selection)

      bottomnotebook:PopupMenu(menu)
    end)

  bottomnotebook:Connect(ID_CLOSE, wx.wxEVT_COMMAND_MENU_SELECTED, function()
      ide:DoWhenIdle(function() bottomnotebook:DeletePage(selection) end)
    end)
  bottomnotebook:Connect(ID_CLOSE, wx.wxEVT_UPDATE_UI, function(event)
      event:Enable(isPreview(bottomnotebook:GetPage(selection)))
    end)
  bottomnotebook:Connect(ID_CLOSESEARCHRESULTS, wx.wxEVT_COMMAND_MENU_SELECTED, function()
      ide:DoWhenIdle(function()
          for p = bottomnotebook:GetPageCount()-1, 0, -1 do
            if isPreview(bottomnotebook:GetPage(p)) then bottomnotebook:DeletePage(p) end
          end
        end)
    end)
  bottomnotebook:Connect(ID_CLOSESEARCHRESULTS, wx.wxEVT_UPDATE_UI, function(event)
      local ispreview = false
      for p = 0, bottomnotebook:GetPageCount()-1 do
        ispreview = ispreview or isPreview(bottomnotebook:GetPage(p))
      end
      event:Enable(ispreview)
    end)

  local errorlog = ide:CreateStyledTextCtrl(bottomnotebook, wx.wxID_ANY,
    wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxBORDER_NONE)

  errorlog:Connect(wx.wxEVT_CONTEXT_MENU,
    function (event)
      local menu = ide:MakeMenu {
          { ID_UNDO, TR("&Undo") },
          { ID_REDO, TR("&Redo") },
          { },
          { ID_CUT, TR("Cu&t") },
          { ID_COPY, TR("&Copy") },
          { ID_PASTE, TR("&Paste") },
          { ID_SELECTALL, TR("Select &All") },
          { },
          { ID_CLEAROUTPUT, TR("C&lear Output Window") },
        }
      PackageEventHandle("onMenuOutput", menu, errorlog, event)
      errorlog:PopupMenu(menu)
    end)

  errorlog:Connect(ID_CLEAROUTPUT, wx.wxEVT_COMMAND_MENU_SELECTED,
    function(event) ClearOutput(true) end)

  local shellbox = ide:CreateStyledTextCtrl(bottomnotebook, wx.wxID_ANY,
    wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxBORDER_NONE)

  local menupos
  shellbox:Connect(wx.wxEVT_CONTEXT_MENU,
    function (event)
      local menu = ide:MakeMenu {
          { ID_UNDO, TR("&Undo") },
          { ID_REDO, TR("&Redo") },
          { },
          { ID_CUT, TR("Cu&t") },
          { ID_COPY, TR("&Copy") },
          { ID_PASTE, TR("&Paste") },
          { ID_SELECTALL, TR("Select &All") },
          { },
          { ID_SELECTCONSOLECOMMAND, TR("&Select Command") },
          { ID_CLEARCONSOLE, TR("C&lear Console Window") },
        }
      menupos = event:GetPosition()
      PackageEventHandle("onMenuConsole", menu, shellbox, event)
      shellbox:PopupMenu(menu)
    end)

  shellbox:Connect(ID_SELECTCONSOLECOMMAND, wx.wxEVT_COMMAND_MENU_SELECTED,
    function(event) ConsoleSelectCommand(menupos) end)
  shellbox:Connect(ID_CLEARCONSOLE, wx.wxEVT_COMMAND_MENU_SELECTED,
    function(event) ide:GetConsole():Erase() end)

  bottomnotebook:AddPage(errorlog, TR("Output"), true)
  bottomnotebook:AddPage(shellbox, TR("Local console"), false)

  bottomnotebook.errorlog = errorlog
  bottomnotebook.shellbox = shellbox

  frame.bottomnotebook = bottomnotebook
  return bottomnotebook
end

local function createProjNotebook(frame)
  local projnotebook = wxaui.wxAuiNotebook(frame, wx.wxID_ANY,
    wx.wxDefaultPosition, wx.wxDefaultSize,
    wxaui.wxAUI_NB_DEFAULT_STYLE + wxaui.wxAUI_NB_TAB_EXTERNAL_MOVE
    - wxaui.wxAUI_NB_CLOSE_ON_ACTIVE_TAB + wx.wxNO_BORDER)

  addDND(projnotebook)

  -- disallow tabs closing
  projnotebook:Connect(wxaui.wxEVT_COMMAND_AUINOTEBOOK_PAGE_CLOSE,
    function (event) event:Veto() end)

  frame.projnotebook = projnotebook
  return projnotebook
end

-- ----------------------------------------------------------------------------
-- Add the child windows to the frame

local frame = createFrame()
ide.frame = frame
createToolBar(frame)
createNotebook(frame)
createProjNotebook(frame)
createBottomNotebook(frame)

do
  local frame = ide.frame
  local mgr = frame.uimgr

  mgr:AddPane(frame.toolBar, wxaui.wxAuiPaneInfo():
    Name("toolbar"):Caption("Toolbar"):
    ToolbarPane():Top():CloseButton(false):PaneBorder(false):
    LeftDockable(false):RightDockable(false))
  mgr:AddPane(frame.notebook, wxaui.wxAuiPaneInfo():
    Name("notebook"):
    CenterPane():PaneBorder(false))
  mgr:AddPane(frame.projnotebook, wxaui.wxAuiPaneInfo():
    Name("projpanel"):CaptionVisible(false):
    MinSize(200,200):FloatingSize(200,400):
    Left():Layer(1):Position(1):PaneBorder(false):
    CloseButton(true):MaximizeButton(false):PinButton(true))
  mgr:AddPane(frame.bottomnotebook, wxaui.wxAuiPaneInfo():
    Name("bottomnotebook"):CaptionVisible(false):
    MinSize(100,100):BestSize(200,200):FloatingSize(400,200):
    Bottom():Layer(1):Position(1):PaneBorder(false):
    CloseButton(true):MaximizeButton(false):PinButton(true))

  if type(ide.config.bordersize) == 'number' then
    for _, uimgr in pairs {mgr, frame.notebook:GetAuiManager(),
      frame.bottomnotebook:GetAuiManager(), frame.projnotebook:GetAuiManager()} do
      uimgr:GetArtProvider():SetMetric(wxaui.wxAUI_DOCKART_SASH_SIZE,
        ide.config.bordersize)
    end
  end

  for _, nb in pairs {frame.bottomnotebook, frame.projnotebook} do
    nb:Connect(wxaui.wxEVT_COMMAND_AUINOTEBOOK_BG_DCLICK,
      function() PaneFloatToggle(nb) end)
  end

  mgr.defaultPerspective = mgr:SavePerspective()
end
