#ifndef _SOCKET_OUTPUT_STREAM_H_
#define _SOCKET_OUTPUT_STREAM_H_

#include "types_def.h"
#include "socket_util.h"
#include "mutex.h"

namespace GXMISC
{
    class CSocketOutputStream 
    {
    public :
        CSocketOutputStream();
        virtual ~CSocketOutputStream( ) ;


    public :
        sint32						write( const char* buf, sint32 len ) ;
        sint32						flush( ) ;
        void						initsize( CSocket* sock, sint32 BufferSize = DEFAULT_SOCKET_OUTPUT_BUFFER_SIZE, sint32 MaxBufferSize = DISCONNECT_SOCKET_OUTPUT_SIZE ) ;
        bool						resize( sint32 size ) ;
        sint32                      capacity ()const { return _bufferLen ; }

        sint32						size()const { return length() ; }
        sint32                      length() const{ return _outputLen; }
        char*						getBuffer()const { return _buffer ; }
        char*						getTail()const { return &(_buffer[_tail]) ; }
        bool						isEmpty()const { return _head==_tail ; }

        void						cleanUp();
        sint32						getHeadPos(){return _head;}
        sint32						getTailPos(){return _tail;}
        sint32						getBuffLen(){return _bufferLen;}

    private:
        sint32						_length( )const ;

    protected :
        CSocket*    _socket ;
        char*		_buffer ;
        sint32		_bufferLen ;
        sint32		_maxBufferLen ;
        sint32		_head ;
        sint32		_tail ;
        CFastLock::Lock_t   _outputLen;             // 当前缓冲区长度, 必须实时改变数值
    };

}

#endif