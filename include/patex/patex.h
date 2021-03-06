#ifndef MOL_PATEX_EXPAT_DEF
#define MOL_PATEX_EXPAT_DEF

#ifndef XML_DYNAMIC
#define XML_STATIC
#endif

#include <expat.h>
#include <iostream>

namespace patex
{
namespace xml
{

class Expat
{
public:
	// con-/destruct
	Expat()
	{
		p_ = XML_ParserCreate(NULL);
		XML_SetElementHandler(p_, startHandler, endHandler);
		XML_SetCharacterDataHandler(p_, charHandler);
		XML_SetUserData(p_, (void *)this);
		XML_SetXmlDeclHandler(p_, declHandler);
	}
	virtual ~Expat()
	{
		XML_ParserFree(p_);
	}
	// use again
	bool reset()
	{
		bool ret = (XML_ParserReset(p_, 0)) == 0 ? false : true;
		XML_SetElementHandler(p_, startHandler, endHandler);
		XML_SetCharacterDataHandler(p_, charHandler);
		XML_SetUserData(p_, (void *)this);
		XML_SetXmlDeclHandler(p_, declHandler);
		return ret;
	}
	// parse it!
	bool parse(const char *what, int len, int isFinal = true)
	{
		if (!XML_Parse(p_, what, len, isFinal))
		{
			XML_Error err = XML_GetErrorCode(p_);
			const XML_LChar *s = XML_ErrorString(err);

			std::cout << err << ": " << s << std::endl;

			return false;
		}
		return true;
	}
	// info
	int line()
	{
		return XML_GetCurrentLineNumber(p_);
	}

	const XML_Char *err()
	{
		return XML_ErrorString(XML_GetErrorCode(p_));
	}

	// handlers

	virtual void character(const XML_Char *s, int len) = 0;
	virtual void start(const XML_Char *el, const XML_Char **attr) = 0;
	virtual void end(const XML_Char *el) = 0;
	virtual void decl(const XML_Char *version, const XML_Char *encoding, int standalone) = 0;

	// handler-imp
	static void charHandler(void *userData, const XML_Char *s, int len)
	{
		((Expat *)userData)->character(s, len);
	}
	static void startHandler(void *userData, const XML_Char *el, const XML_Char **attr)
	{
		((Expat *)userData)->start(el, attr);
	}
	static void endHandler(void *userData, const XML_Char *el)
	{
		((Expat *)userData)->end(el);
	}

	static void declHandler(void *userData, const XML_Char *version, const XML_Char *encoding, int standalone)
	{
		((Expat *)userData)->decl(version, encoding, standalone);
	}

protected:
	// the expat object
	XML_Parser p_;
};

} // namespace xml
} // namespace patex

#endif
