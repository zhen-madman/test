/* /////////////////////////////////////////////////////////////////////////
 * File:        stlsoft/string/string_slice.hpp
 *
 * Purpose:     Defines the string_slice class template.
 *
 * Created:     22nd February 2010
 * Updated:     21st June 2010
 *
 * Home:        http://stlsoft.org/
 *
 * Copyright (c) 2010, Matthew Wilson and Synesis Software
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
 * - Neither the name(s) of Matthew Wilson and Synesis Software nor the
 *   names of any contributors may be used to endorse or promote products
 *   derived from this software without specific prior written permission.
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


/** \file stlsoft/string/string_slice.hpp
 *
 * \brief [C++] Definition of the stlsoft::string_slice class template
 *   (\ref group__library__string "String" Library).
 */

#ifndef STLSOFT_INCL_STLSOFT_STRING_HPP_STRING_SLICE
#define STLSOFT_INCL_STLSOFT_STRING_HPP_STRING_SLICE

#ifndef STLSOFT_DOCUMENTATION_SKIP_SECTION
# define STLSOFT_VER_STLSOFT_STRING_HPP_STRING_SLICE_MAJOR      1
# define STLSOFT_VER_STLSOFT_STRING_HPP_STRING_SLICE_MINOR      1
# define STLSOFT_VER_STLSOFT_STRING_HPP_STRING_SLICE_REVISION   2
# define STLSOFT_VER_STLSOFT_STRING_HPP_STRING_SLICE_EDIT       9
#endif /* !STLSOFT_DOCUMENTATION_SKIP_SECTION */

/* /////////////////////////////////////////////////////////////////////////
 * Includes
 */

#include <stlsoft/stlsoft_1_10.h> /* Requires STLSoft 1.10 alpha header during alpha phase */
#include <stlsoft/quality/contract.h>
#include <stlsoft/quality/cover.h>

#ifndef STLSOFT_INCL_STLSOFT_H_STLSOFT
# include <stlsoft/stlsoft.h>
#endif /* !STLSOFT_INCL_STLSOFT_H_STLSOFT */
#ifndef STLSOFT_INCL_STLSOFT_SHIMS_ACCESS_STRING_STD_H_C_STRING
# include <stlsoft/shims/access/string/std/c_string.h>
#endif /* !STLSOFT_INCL_STLSOFT_SHIMS_ACCESS_STRING_STD_H_C_STRING */
#ifndef STLSOFT_INCL_STLSOFT_STRING_HPP_CHAR_TRAITS
# include <stlsoft/string/char_traits.hpp>
#endif /* !STLSOFT_INCL_STLSOFT_STRING_HPP_CHAR_TRAITS */

/* /////////////////////////////////////////////////////////////////////////
 * Namespace
 */

#ifndef STLSOFT_NO_NAMESPACE
namespace stlsoft
{
#endif /* STLSOFT_NO_NAMESPACE */

/* /////////////////////////////////////////////////////////////////////////
 * Classes
 */

/// A type for describing string slices
template<   ss_typename_param_k C
        ,   ss_typename_param_k T = stlsoft_char_traits<C>
        >
struct string_slice
{
public: // Member Types
    /// The character type
    typedef C                                       char_type;
    /// The traits type
    typedef T                                       traits_type;
    /// The size type
    typedef ss_size_t                               size_type;
    /// The class type
    typedef string_slice<char_type, traits_type>    class_type;
    /// The boolean type
    typedef ss_bool_t                               bool_type;
    /// The comparison type
    typedef int                                     int_type;

public: // Member Variables
    size_type           len;    /*!< The length of the slice */
    char_type const*    ptr;    /*!< The pointer of the slice */

public: // Construction
    /// Default constructor
    string_slice()
        : len(0u)
        , ptr(NULL)
    {}
    /// Constructs instance from string pointer and length
    string_slice(char_type const* s, size_type n)
        : len(n)
        , ptr(s)
    {
        STLSOFT_ASSERT(0u == n || NULL != s);
    }
    /// Constructs instance from string pointer and length
    ss_explicit_k string_slice(char_type const* s)
        : ptr( stlsoft_ns_qual(c_str_data)(s))
        , len( stlsoft_ns_qual(c_str_len)(s))
    {}
    /// Copy constructor
    string_slice(string_slice const& rhs)
        : len(rhs.len)
        , ptr(rhs.ptr)
    {}

    /// Copy assignment operator
    string_slice& operator =(string_slice const& rhs)
    {
        len = rhs.len;
        ptr = rhs.ptr;

        return *this;
    }

    /// Swaps the contents of this slice with \c rhs
    void swap(class_type& rhs) stlsoft_throw_0()
    {
        std_swap(len, rhs.len);
        std_swap(ptr, rhs.ptr);
    }

public: // Comparison
    /// Determines whether the current instance is equal to the given
    /// instance
    bool_type equals(class_type const& rhs) const
    {
        return len == rhs.len && (ptr == rhs.ptr || 0 == traits_type::compare(ptr, rhs.ptr, len));
    }

    /// Determines whether the current instance is equal to the given
    /// string
    bool_type equals(char_type const* s) const
    {
        return equals(class_type(s));
    }

    /// Compares the current instance with the given instance
    int_type compare(class_type const& rhs) const
    {
        size_type   n   =   (len < rhs.len) ? len : rhs.len;
        int_type    r   =   traits_type::compare(ptr, rhs.ptr, n);

        if( 0 == r &&
            (len != rhs.len))
        {
            return (len < rhs.len) ? -1 : +1;
        }

        return r;
    }

    /// Compares the current instance with the given string
    int_type compare(char_type const* s) const
    {
        return compare(class_type(s));
    }
};

/* /////////////////////////////////////////////////////////////////////////
 * Comparison operators
 */

/* slice const& */

template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_typename_type_k string_slice<C, T>::bool_type operator ==(
    string_slice<C, T> const& lhs
,   string_slice<C, T> const& rhs
)
{
    return lhs.equals(rhs);
}

template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_typename_type_k string_slice<C, T>::bool_type operator !=(
    string_slice<C, T> const& lhs
,   string_slice<C, T> const& rhs
)
{
    return !lhs.equals(rhs);
}

template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_typename_type_k string_slice<C, T>::bool_type operator <(
    string_slice<C, T> const& lhs
,   string_slice<C, T> const& rhs
)
{
    return lhs.compare(rhs) < 0;
}

template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_typename_type_k string_slice<C, T>::bool_type operator >(
    string_slice<C, T> const& lhs
,   string_slice<C, T> const& rhs
)
{
    return lhs.compare(rhs) > 0;
}

template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_typename_type_k string_slice<C, T>::bool_type operator <=(
    string_slice<C, T> const& lhs
,   string_slice<C, T> const& rhs
)
{
    return lhs.compare(rhs) <= 0;
}

template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_typename_type_k string_slice<C, T>::bool_type operator >=(
    string_slice<C, T> const& lhs
,   string_slice<C, T> const& rhs
)
{
    return lhs.compare(rhs) >= 0;
}

/* char_type const* */

template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_typename_type_k string_slice<C, T>::bool_type operator ==(
    string_slice<C, T> const&                               lhs
,   ss_typename_type_k string_slice<C, T>::char_type const* rhs
)
{
    return lhs.equals(rhs);
}

template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_typename_type_k string_slice<C, T>::bool_type operator !=(
    string_slice<C, T> const&                               lhs
,   ss_typename_type_k string_slice<C, T>::char_type const* rhs
)
{
    return !lhs.equals(rhs);
}

template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_typename_type_k string_slice<C, T>::bool_type operator <(
    string_slice<C, T> const&                               lhs
,   ss_typename_type_k string_slice<C, T>::char_type const* rhs
)
{
    return lhs.compare(rhs) < 0;
}

template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_typename_type_k string_slice<C, T>::bool_type operator >(
    string_slice<C, T> const&                               lhs
,   ss_typename_type_k string_slice<C, T>::char_type const* rhs
)
{
    return lhs.compare(rhs) > 0;
}

template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_typename_type_k string_slice<C, T>::bool_type operator <=(
    string_slice<C, T> const&                               lhs
,   ss_typename_type_k string_slice<C, T>::char_type const* rhs
)
{
    return lhs.compare(rhs) <= 0;
}

template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_typename_type_k string_slice<C, T>::bool_type operator >=(
    string_slice<C, T> const&                               lhs
,   ss_typename_type_k string_slice<C, T>::char_type const* rhs
)
{
    return lhs.compare(rhs) >= 0;
}

/* /////////////////////////////////////////////////////////////////////////
 * swapping
 */

template <ss_typename_param_k C, ss_typename_param_k T>
inline void swap(
    string_slice<C, T>& lhs
,   string_slice<C, T>& rhs
)
{
    lhs.swap(rhs);
}

/* /////////////////////////////////////////////////////////////////////////
 * Shims
 */

/* string_slice<ss_char_a_t> const& */

inline ss_char_a_t const* c_str_data_a(string_slice<ss_char_a_t> const& slice)
{
    return (0u == slice.len) ? "" : slice.ptr;
}
inline ss_size_t c_str_len_a(string_slice<ss_char_a_t> const& slice)
{
    return slice.len;
}

inline ss_char_w_t const* c_str_data_w(string_slice<ss_char_w_t> const& slice)
{
    return (0u == slice.len) ? L"" : slice.ptr;
}
inline ss_size_t c_str_len_w(string_slice<ss_char_w_t> const& slice)
{
    return slice.len;
}

template <ss_typename_param_k C, ss_typename_param_k T>
inline C const* c_str_data(string_slice<C, T> const& slice)
{
    static C const empty = '\0';

    return (0u == slice.len) ? &empty : slice.ptr;
}
template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_size_t c_str_len(string_slice<C, T> const& slice)
{
    return slice.len;
}


/* string_slice<ss_char_a_t> const* */

inline ss_char_a_t const* c_str_data_a(string_slice<ss_char_a_t> const* slice)
{
    return (NULL == slice) ? "" : c_str_data_a(*slice);
}
inline ss_size_t c_str_len_a(string_slice<ss_char_a_t> const* slice)
{
    return (NULL == slice) ? 0u : c_str_len_a(*slice);
}

inline ss_char_w_t const* c_str_data_w(string_slice<ss_char_w_t> const* slice)
{
    return (NULL == slice) ? L"" : c_str_data_w(*slice);
}
inline ss_size_t c_str_len_w(string_slice<ss_char_w_t> const* slice)
{
    return (NULL == slice) ? 0u : c_str_len_w(*slice);
}

template <ss_typename_param_k C, ss_typename_param_k T>
inline C const* c_str_data(string_slice<C, T> const* slice)
{
    static C const empty = '\0';

    return (NULL == slice) ? &empty : c_str_data(*slice);
}
template <ss_typename_param_k C, ss_typename_param_k T>
inline ss_size_t c_str_len(string_slice<C, T> const* slice)
{
    return (NULL == slice) ? 0u : c_str_len(*slice);
}

/* ////////////////////////////////////////////////////////////////////// */

#ifndef STLSOFT_NO_NAMESPACE
} // namespace stlsoft
#endif /* STLSOFT_NO_NAMESPACE */

/* ////////////////////////////////////////////////////////////////////// */

#endif /* !STLSOFT_INCL_STLSOFT_STRING_HPP_STRING_SLICE */

/* ///////////////////////////// end of file //////////////////////////// */
