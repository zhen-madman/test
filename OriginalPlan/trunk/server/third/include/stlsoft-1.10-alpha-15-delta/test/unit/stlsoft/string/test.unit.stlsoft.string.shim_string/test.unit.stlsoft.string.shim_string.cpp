/* /////////////////////////////////////////////////////////////////////////
 * File:        test.unit.stlsoft.string.shim_string.cpp
 *
 * Purpose:     Implementation file for the test.unit.stlsoft.string.shim_string project.
 *
 * Created:     9th November 2008
 * Updated:     13th October 2010
 *
 * Status:      Wizard-generated
 *
 * License:     (Licensed under the Synesis Software Open License)
 *
 *              Copyright (c) 2008-2010, Synesis Software Pty Ltd.
 *              All rights reserved.
 *
 *              www:        http://www.synesis.com.au/software
 *
 * ////////////////////////////////////////////////////////////////////// */


/* /////////////////////////////////////////////////////////////////////////
 * Test component header file include(s)
 */

#include <stlsoft/string/shim_string.hpp>

/* /////////////////////////////////////////////////////////////////////////
 * Compiler compatibility
 */

#if defined(__BORLANDC__)
# pragma warn -8019
#endif /* compiler */

/* /////////////////////////////////////////////////////////////////////////
 * Includes
 */

/* xCover Header Files */
#ifdef STLSOFT_USE_XCOVER
# include <xcover/xcover.h>
#endif /* STLSOFT_USE_XCOVER */

/* xTests Header Files */
#include <xtests/xtests.h>

/* STLSoft Header Files */
#include <stlsoft/stlsoft.h>

/* Standard C++ Header Files */
#include <string>

/* Standard C Header Files */
#include <stdlib.h>

/* /////////////////////////////////////////////////////////////////////////
 * Forward declarations
 */

namespace
{

	static void test_sizes(void);
	static void test_construction(void);
	static void test_method_calls(void);
	static void test_constructor_c_string(void);
	static void test_constructor_range_string(void);
	static void test_constructor_length(void);
	static void test_write(void);
	static void test_truncate(void);
	static void test_swap(void);
	static void test_1_8(void);
	static void test_1_9(void);
	static void test_append_c_string(void);
	static void test_append_c_string_after_truncate(void);
	static void test_1_12(void);
	static void test_null_string(void);
	static void test_reserve(void);
	static void test_resize(void);
	static void test_1_16(void);
	static void test_1_17(void);
	static void test_1_18(void);
	static void test_1_19(void);

} // anonymous namespace

/* /////////////////////////////////////////////////////////////////////////
 * Main
 */

int main(int argc, char **argv)
{
	int retCode = EXIT_SUCCESS;
	int verbosity = 2;

	XTESTS_COMMANDLINE_PARSEVERBOSITY(argc, argv, &verbosity);

	if(XTESTS_START_RUNNER("test.unit.stlsoft.string.shim_string", verbosity))
	{
		XTESTS_RUN_CASE(test_sizes);
		XTESTS_RUN_CASE(test_construction);
		XTESTS_RUN_CASE(test_method_calls);
		XTESTS_RUN_CASE(test_constructor_c_string);
		XTESTS_RUN_CASE(test_constructor_range_string);
		XTESTS_RUN_CASE(test_constructor_length);
		XTESTS_RUN_CASE(test_write);
		XTESTS_RUN_CASE(test_truncate);
		XTESTS_RUN_CASE(test_swap);
		XTESTS_RUN_CASE(test_1_8);
		XTESTS_RUN_CASE(test_1_9);
		XTESTS_RUN_CASE(test_append_c_string);
		XTESTS_RUN_CASE(test_append_c_string_after_truncate);
		XTESTS_RUN_CASE(test_1_12);
		XTESTS_RUN_CASE(test_null_string);
		XTESTS_RUN_CASE(test_reserve);
		XTESTS_RUN_CASE(test_resize);
		XTESTS_RUN_CASE(test_1_16);
		XTESTS_RUN_CASE(test_1_17);
		XTESTS_RUN_CASE(test_1_18);
		XTESTS_RUN_CASE(test_1_19);

#ifdef STLSOFT_USE_XCOVER
		XCOVER_REPORT_ALIAS_COVERAGE("shim_string", NULL);
#endif /* STLSOFT_USE_XCOVER */

		XTESTS_PRINT_RESULTS();

		XTESTS_END_RUNNER_UPDATE_EXITCODE(&retCode);
	}

	return retCode;
}

/* /////////////////////////////////////////////////////////////////////////
 * Test function implementations
 */

namespace
{

	const char alphabet[] = "abcdefghijklmnopqrstuvwxyz";

static void test_sizes()
{
	XTESTS_TEST_INTEGER_LESS_OR_EQUAL(sizeof(void*) * 2 + sizeof(stlsoft::auto_buffer<char, 4>), sizeof(stlsoft::basic_shim_string<char, 4>));
	XTESTS_TEST_INTEGER_LESS_OR_EQUAL(sizeof(void*) * 2 + sizeof(stlsoft::auto_buffer<char, 16>), sizeof(stlsoft::basic_shim_string<char, 16>));
	XTESTS_TEST_INTEGER_LESS_OR_EQUAL(sizeof(void*) * 2 + sizeof(stlsoft::auto_buffer<char, 32>), sizeof(stlsoft::basic_shim_string<char, 32>));
	XTESTS_TEST_INTEGER_LESS_OR_EQUAL(sizeof(void*) * 2 + sizeof(stlsoft::auto_buffer<char, 64>), sizeof(stlsoft::basic_shim_string<char, 64>));
	XTESTS_TEST_INTEGER_LESS_OR_EQUAL(sizeof(void*) * 2 + sizeof(stlsoft::auto_buffer<char, 256>), sizeof(stlsoft::basic_shim_string<char, 256>));
}

static void test_construction()
{
	stlsoft::basic_shim_string<char>	str0;

	XTESTS_TEST_BOOLEAN_TRUE(str0.empty());
	XTESTS_TEST_INTEGER_EQUAL(0u, str0.size());
	XTESTS_TEST_INTEGER_EQUAL(0u, static_cast<size_t>(str0));
	XTESTS_TEST_INTEGER_NOT_EQUAL(0u, str0.internal_size());
	XTESTS_TEST_POINTER_NOT_EQUAL(NULL, str0);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str0);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str0.data());

	stlsoft::basic_shim_string<char>	str1(size_t(0u));

	XTESTS_TEST_BOOLEAN_TRUE(str1.empty());
	XTESTS_TEST_INTEGER_EQUAL(0u, str1.size());
	XTESTS_TEST_INTEGER_EQUAL(0u, static_cast<size_t>(str1));
	XTESTS_TEST_INTEGER_NOT_EQUAL(0u, str1.internal_size());
	XTESTS_TEST_POINTER_NOT_EQUAL(NULL, str1);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str1);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str1.data());

	const stlsoft::basic_shim_string<char>	str2("");

	XTESTS_TEST_BOOLEAN_TRUE(str2.empty());
	XTESTS_TEST_INTEGER_EQUAL(0u, str2.size());
	XTESTS_TEST_INTEGER_EQUAL(0u, static_cast<size_t>(str2));
	XTESTS_TEST_INTEGER_NOT_EQUAL(0u, str2.internal_size());
	XTESTS_TEST_POINTER_NOT_EQUAL(NULL, str2);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str2);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str2.data());

	stlsoft::basic_shim_string<char>	str3("", 0);

	XTESTS_TEST_BOOLEAN_TRUE(str3.empty());
	XTESTS_TEST_INTEGER_EQUAL(0u, str3.size());
	XTESTS_TEST_INTEGER_EQUAL(0u, static_cast<size_t>(str3));
	XTESTS_TEST_INTEGER_NOT_EQUAL(0u, str3.internal_size());
	XTESTS_TEST_POINTER_NOT_EQUAL(NULL, str3);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str3);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str3.data());

	stlsoft::basic_shim_string<char>	str4(NULL, 0);

	XTESTS_TEST_BOOLEAN_TRUE(str4.empty());
	XTESTS_TEST_INTEGER_EQUAL(0u, str4.size());
	XTESTS_TEST_INTEGER_EQUAL(0u, static_cast<size_t>(str4));
	XTESTS_TEST_INTEGER_NOT_EQUAL(0u, str4.internal_size());
	XTESTS_TEST_POINTER_NOT_EQUAL(NULL, str4);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str4);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str4.data());

	stlsoft::basic_shim_string<char>	str5(str1);

	XTESTS_TEST_BOOLEAN_TRUE(str5.empty());
	XTESTS_TEST_INTEGER_EQUAL(0u, str5.size());
	XTESTS_TEST_INTEGER_EQUAL(0u, static_cast<size_t>(str5));
	XTESTS_TEST_INTEGER_NOT_EQUAL(0u, str5.internal_size());
	XTESTS_TEST_POINTER_NOT_EQUAL(NULL, str5);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str5);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str5.data());
}

static void test_method_calls()
{
	stlsoft::basic_shim_string<char>	str1(size_t(0u));

	str1.write("");
	str1.truncate(0);
	str1.size();
	str1.data();

	XTESTS_TEST_PASSED();
}

static void test_constructor_length()
{
	stlsoft::basic_shim_string<char>	str(5u);

	XTESTS_TEST_BOOLEAN_FALSE(str.empty());
	XTESTS_TEST_INTEGER_EQUAL(5u, str.size());
	XTESTS_TEST_INTEGER_EQUAL(5u, static_cast<size_t>(str));
	XTESTS_TEST_POINTER_NOT_EQUAL(NULL, str);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("", str.data());
}

static void test_constructor_c_string()
{
	stlsoft::basic_shim_string<char>	str("a");

	XTESTS_TEST_BOOLEAN_FALSE(str.empty());
	XTESTS_TEST_INTEGER_EQUAL(1u, str.size());
	XTESTS_TEST_INTEGER_EQUAL(1u, static_cast<size_t>(str));
	XTESTS_TEST_POINTER_NOT_EQUAL(NULL, str);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("a", str);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("a", str.data());
}

static void test_constructor_range_string()
{
	stlsoft::basic_shim_string<char>	str("abcdefghijkl", 3);

	XTESTS_TEST_BOOLEAN_FALSE(str.empty());
	XTESTS_TEST_INTEGER_EQUAL(3u, str.size());
	XTESTS_TEST_INTEGER_EQUAL(3u, static_cast<size_t>(str));
	XTESTS_TEST_POINTER_NOT_EQUAL(NULL, str);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("abc", str);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("abc", str.data());
}

static void test_write()
{
	stlsoft::basic_shim_string<char>	str(3);

	str.write("abc");

	XTESTS_TEST_BOOLEAN_FALSE(str.empty());
	XTESTS_TEST_INTEGER_EQUAL(3u, str.size());
	XTESTS_TEST_INTEGER_EQUAL(3u, static_cast<size_t>(str));
	XTESTS_TEST_POINTER_NOT_EQUAL(NULL, str);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("abc", str);
	XTESTS_TEST_MULTIBYTE_STRING_EQUAL("abc", str.data());
}

static void test_truncate()
{
	stlsoft::basic_shim_string<char>	str("abcdefghijklmnopqrstuvwx");

	{ for(size_t i = 0;; ++i)
	{
		size_t numTriplets = (8 - i);

		XTESTS_TEST_INTEGER_EQUAL(3u * numTriplets, str.size());
		XTESTS_TEST_MULTIBYTE_STRING_EQUAL(std::string(alphabet, 3u * numTriplets), str);

		if(8 == i)
		{
			break;
		}

		str.truncate(3u * (numTriplets - 1));

		XTESTS_TEST_INTEGER_EQUAL(3u * (numTriplets - 1), str.size());
		XTESTS_TEST_MULTIBYTE_STRING_EQUAL(std::string(alphabet, 3u * (numTriplets - 1)), str);
	}}
}

static void test_swap()
{
    {
        stlsoft::basic_shim_string<char>  s1("abc");
        stlsoft::basic_shim_string<char>  s2("defghi");

        XTESTS_TEST_INTEGER_EQUAL(3u, s1.size());
        XTESTS_TEST_MULTIBYTE_STRING_EQUAL("abc", s1);
        XTESTS_TEST_INTEGER_EQUAL(6u, s2.size());
        XTESTS_TEST_MULTIBYTE_STRING_EQUAL("defghi", s2);

        s1.swap(s2);

        XTESTS_TEST_INTEGER_EQUAL(6u, s1.size());
        XTESTS_TEST_MULTIBYTE_STRING_EQUAL("defghi", s1);
        XTESTS_TEST_INTEGER_EQUAL(3u, s2.size());
        XTESTS_TEST_MULTIBYTE_STRING_EQUAL("abc", s2);
    }

    {
        stlsoft::basic_shim_string<char>  s1("abcdefghijklmnopqrstuvwxyz");
        stlsoft::basic_shim_string<char>  s2("ABCDEFGHIJKLMNOPQRSTUVWXYZ");

        XTESTS_TEST_INTEGER_EQUAL(26u, s1.size());
        XTESTS_TEST_MULTIBYTE_STRING_EQUAL("abcdefghijklmnopqrstuvwxyz", s1);
        XTESTS_TEST_INTEGER_EQUAL(26u, s2.size());
        XTESTS_TEST_MULTIBYTE_STRING_EQUAL("ABCDEFGHIJKLMNOPQRSTUVWXYZ", s2);

        s1.swap(s2);

        XTESTS_TEST_INTEGER_EQUAL(26u, s1.size());
        XTESTS_TEST_MULTIBYTE_STRING_EQUAL("ABCDEFGHIJKLMNOPQRSTUVWXYZ", s1);
        XTESTS_TEST_INTEGER_EQUAL(26u, s2.size());
        XTESTS_TEST_MULTIBYTE_STRING_EQUAL("abcdefghijklmnopqrstuvwxyz", s2);
    }
}

static void test_1_8()
{
}

static void test_1_9()
{
}

static void test_append_c_string()
{
	char const* strings[] =
	{
			"abc"
		,	"def"
		,	"ghi"
		,	"jkl"
		,	"mno"
		,	"pqr"
		,	"stu"
		,	"vwx"
	};

	stlsoft::basic_shim_string<char>	str(size_t(0u));

	{ for(size_t i = 0; i != STLSOFT_NUM_ELEMENTS(strings); ++i)
	{
		str.append(strings[i]);

		XTESTS_TEST_INTEGER_EQUAL(3u * (i + 1), str.size());
		XTESTS_TEST_MULTIBYTE_STRING_EQUAL(std::string(alphabet, 3u * (i + 1)), str);
	}}
}

static void test_append_c_string_after_truncate()
{
	char const* strings[] =
	{
			"abc"
		,	"def"
		,	"ghi"
		,	"jkl"
		,	"mno"
		,	"pqr"
		,	"stu"
		,	"vwx"
	};

	stlsoft::basic_shim_string<char>	str(24u);

	char const*	const ptr = str;

	str.truncate(0u);

	{ for(size_t i = 0; i != STLSOFT_NUM_ELEMENTS(strings); ++i)
	{
		str.append(strings[i]);

		XTESTS_TEST_INTEGER_EQUAL(3u * (i + 1), str.size());
		XTESTS_TEST_POINTER_EQUAL(ptr, str);
		XTESTS_TEST_MULTIBYTE_STRING_EQUAL(std::string(alphabet, 3u * (i + 1)), str);
	}}
}

static void test_1_12()
{
}

static void test_null_string()
{
	{
		stlsoft::basic_shim_string<char, 64, true>  s(size_t(0u));

		XTESTS_TEST_INTEGER_EQUAL(0u, s.size());
		XTESTS_TEST_INTEGER_EQUAL(0u, static_cast<size_t>(s));
		XTESTS_TEST_INTEGER_EQUAL(0u, s.size());
		XTESTS_TEST_POINTER_EQUAL(NULL, s);
		XTESTS_TEST_INTEGER_EQUAL(0u, static_cast<size_t>(s));
	}
}

static void test_reserve()
{
	{
		stlsoft::basic_shim_string<char>    s(size_t(0u));

		XTESTS_TEST_BOOLEAN_TRUE(s.empty());
		XTESTS_TEST_INTEGER_EQUAL(0u, s.size());

		s.reserve(0u);

		XTESTS_TEST_BOOLEAN_TRUE(s.empty());
		XTESTS_TEST_INTEGER_EQUAL(0u, s.size());

		s.reserve(1u);

		XTESTS_TEST_BOOLEAN_TRUE(s.empty());
		XTESTS_TEST_INTEGER_EQUAL(0u, s.size());

		s.reserve(0u);

		XTESTS_TEST_BOOLEAN_TRUE(s.empty());
		XTESTS_TEST_INTEGER_EQUAL(0u, s.size());

		s.reserve(100u);

		XTESTS_TEST_BOOLEAN_TRUE(s.empty());
		XTESTS_TEST_INTEGER_EQUAL(0u, s.size());

		s.reserve(0u);

		XTESTS_TEST_BOOLEAN_TRUE(s.empty());
		XTESTS_TEST_INTEGER_EQUAL(0u, s.size());
	}

}

static void test_resize()
{
	{
		stlsoft::basic_shim_string<char>    s(size_t(0u));

		XTESTS_TEST_BOOLEAN_TRUE(s.empty());
		XTESTS_TEST_INTEGER_EQUAL(0u, s.size());

		s.resize(0u);

		XTESTS_TEST_BOOLEAN_TRUE(s.empty());
		XTESTS_TEST_INTEGER_EQUAL(0u, s.size());

		s.resize(1u);

		XTESTS_TEST_BOOLEAN_FALSE(s.empty());
		XTESTS_TEST_INTEGER_EQUAL(1u, s.size());

		s.resize(0u);

		XTESTS_TEST_BOOLEAN_TRUE(s.empty());
		XTESTS_TEST_INTEGER_EQUAL(0u, s.size());

		s.resize(100u);

		XTESTS_TEST_BOOLEAN_FALSE(s.empty());
		XTESTS_TEST_INTEGER_EQUAL(100u, s.size());

		s.resize(0u);

		XTESTS_TEST_BOOLEAN_TRUE(s.empty());
		XTESTS_TEST_INTEGER_EQUAL(0u, s.size());
	}

}

static void test_1_16()
{
}

static void test_1_17()
{
}

static void test_1_18()
{
}

static void test_1_19()
{
}


} // anonymous namespace

/* ///////////////////////////// end of file //////////////////////////// */
