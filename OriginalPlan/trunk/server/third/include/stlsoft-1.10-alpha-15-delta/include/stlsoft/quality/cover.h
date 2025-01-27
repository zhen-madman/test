/* /////////////////////////////////////////////////////////////////////////
 * File:        stlsoft/quality/cover.h
 *
 * Purpose:     Defines the code coverage constructs used in the
 *              STLSoft libraries.
 *
 * Created:     13th October 2008
 * Updated:     6th August 2009
 *
 * Home:        http://www.stlsoft.org/
 *
 * Copyright (c) 2008-2009, Matthew Wilson and Synesis Software
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the names of Matthew Wilson and Synesis Software nor the names
 *   of any contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ////////////////////////////////////////////////////////////////////// */


/** \file stlsoft/quality/cover.h
 *
 * [C, C++] Defines the code coverage constructs used in the
 *   STLSoft libraries.
 */

#ifndef STLSOFT_INCL_STLSOFT_QUALITY_H_COVER
#define STLSOFT_INCL_STLSOFT_QUALITY_H_COVER

/* /////////////////////////////////////////////////////////////////////////
 * Version information
 */

#ifndef STLSOFT_DOCUMENTATION_SKIP_SECTION
# define STLSOFT_VER_STLSOFT_QUALITY_H_COVER_MAJOR       1
# define STLSOFT_VER_STLSOFT_QUALITY_H_COVER_MINOR       0
# define STLSOFT_VER_STLSOFT_QUALITY_H_COVER_REVISION    1
# define STLSOFT_VER_STLSOFT_QUALITY_H_COVER_EDIT        2
#endif /* !STLSOFT_DOCUMENTATION_SKIP_SECTION */

/* /////////////////////////////////////////////////////////////////////////
 * Includes
 */

#include <stlsoft/stlsoft_1_10.h> /* Requires STLSoft 1.10 alpha header */

#ifndef STLSOFT_INCL_STLSOFT_H_STLSOFT
# include <stlsoft/stlsoft.h>
#endif /* !STLSOFT_INCL_STLSOFT_H_STLSOFT */

#ifdef STLSOFT_USE_XCOVER
# include <xcover/xcover.h>
#else /* ? STLSOFT_USE_XCOVER */
# include <stlsoft/stlsoft.h>
#endif /* STLSOFT_USE_XCOVER */

/* /////////////////////////////////////////////////////////////////////////
 * Macros
 */

#ifdef STLSOFT_USE_XCOVER

# define STLSOFT_COVER_MARK_LINE()              XCOVER_MARK_LINE()

#else /* ? STLSOFT_USE_XCOVER */

# define STLSOFT_COVER_MARK_LINE()              stlsoft_static_cast(void, 0)

#endif /* STLSOFT_USE_XCOVER */

/* ////////////////////////////////////////////////////////////////////// */

#endif /* STLSOFT_INCL_STLSOFT_QUALITY_H_COVER */

/* ///////////////////////////// end of file //////////////////////////// */
