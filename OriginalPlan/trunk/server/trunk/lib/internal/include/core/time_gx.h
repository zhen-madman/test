
// Copyright (C) 2010  Winch Gate Property Limited
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

#ifndef TIME_H
#define TIME_H

#include "types_def.h"

namespace GXMISC
{
    /// New time types
    typedef double TGameTime;		// Time according to the game (used for determining day, night...) (double in seconds)
    typedef uint32 TGameCycle;		// Integer game cycle count from the game (in game ticks)
    typedef double TLocalTime;		// Time according to the machine's local clock (double in seconds)
    typedef sint64 TCPUCycle;		// Integer cycle count from the CPU (for profiling in cpu ticks)
    
    /// Old time type
    typedef sint64 TTime;           
    typedef sint64 TTicks; 


    /**
    * This class provide a independant local time system.
    * \author Vianney Lecroart, Olivier Cado
    * \author Nevrax France
    * \date 2000-2005
    */
    class CTime
    {
    public:

        /** Return the number of second since midnight (00:00:00), January 1, 1970,
        * coordinated universal time, according to the system clock.
        * The time returned is local, ie. it has the local time ajustement, including
        * daylight saving if applicable.
        * This values is the same on all computer if computers are synchronized (with NTP for example).
        */
        static uint32	    GetSecondsSince1970 ();

        /** Return the local time in milliseconds.
        * Use it only to measure time difference, the absolute value does not mean anything.
        * On Unix, getLocalTime() will try to use the Monotonic Clock if available, otherwise
        * the value can jump backwards if the system time is changed by a user or a NTP time sync process.
        * The value is different on 2 different computers; use the CUniTime class to get a universal
        * time that is the same on all computers.
        * \warning On Win32, the value is on 32 bits only. It wraps around to 0 every about 49.71 days.
        */
        static TTime	    GetLocalTime ();

        /** Return the time in processor ticks. Use it for profile purpose.
        * If the performance time is not supported on this hardware, it returns 0.
        * \warning On a multiprocessor system, the value returned by each processor may
        * be different. The only way to workaround this is to set a processor affinity
        * to the measured thread.
        * \warning The speed of tick increase can vary (especially on laptops or CPUs with
        * power management), so profiling several times and computing the average could be
        * a wise choice.
        */
        static TTicks	    GetPerformanceTime ();

        /** Convert a ticks count into second. If the performance time is not supported on this
        * hardware, it returns 0.0.
        */
        static double	    TicksToSecond (TTicks ticks);

        /** Build a human readable string of a time difference in second.
        *	The result will be of the form '1 years 2 months 2 days 10 seconds'
        */
        static std::string	GetHumanRelativeTime(sint32 nbSeconds);

#ifdef OS_WINDOWS
        /** Return the offset in 10th of micro sec between the windows base time (
        *	01-01-1601 0:0:0 UTC) and the unix base time (01-01-1970 0:0:0 UTC).
        *	This value is used to convert windows system and file time back and
        *	forth to unix time (aka epoch)
        */
        static uint64       GetWindowsToUnixBaseTimeOffset();
#endif

    };

} // GXMISC

#endif // TIME_H

/* End of time_gx.h */
