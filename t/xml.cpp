#include "gtest/gtest.h"

#include "patex/document.h"

using namespace patex;


class BasicTest : public ::testing::Test {
 protected:

  virtual void SetUp() 
  {}

  virtual void TearDown() 
  {}
};

const char* testXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\r\n"
"<root xmlns='http://blabla' xmlns:x='http://xyz'>\r\n"
"<x:element>\r\n"
"<name id='&quot;x'>littlemole</name>\r\n"
"<email>littlemole@oha7.org</email>\r\n"
"<url>n/a</url>\r\n"
"</x:element>\r\n"
"</root>\r\n";

void dump_node(xml::NodePtr n)
{
	std::cout << n->nodeName() << std::endl;
	auto e = std::dynamic_pointer_cast<xml::Element>(n);
	std::cout << e->innerXml() << std::endl;
}


TEST_F(BasicTest, SimpleXml)
{
	xml::DocumentPtr doc = xml::Document::create();
	doc->parse(testXML);

	xml::NodePtr root = doc->documentElement()->childNodes()->item(0);
	dump_node(root);

	xml::NodePtr elem = root->childNodes()->getChildByName("element");
	dump_node(elem);

	std::cout << elem->prefix() << ":" << elem->namespaceURI() << std::endl;
	std::cout << elem->getPrefixFromNS("http://xyz") << ":" << elem->getNSfromPrefix("x") << std::endl;

	xml::NodePtr name = elem->childNodes()->getChildByName("name");
	dump_node(name);

	std::string n = ((xml::Element*)(name.get()))->attr("id");
	std::cout << n << std::endl;


	std::cout << name->prefix() << ":" << name->namespaceURI() << std::endl;
	std::cout << name->getPrefixFromNS("http://blabla") << ":" << name->getNSfromPrefix("") << std::endl;

	xml::NodePtr email = elem->childNodes()->getChildByName("email");
	dump_node(email);

	xml::NodePtr url = elem->childNodes()->getChildByName("url");
	dump_node(url);

	((xml::Element*)url.get())->setAttributeNS("ns1:key","urn:valid/something","the value");
	dump_node(elem);

	auto el = doc->createElementNS("ns2:myel", "http://thens/");
	elem->appendChild(el);
	dump_node(elem);
}


int main(int argc, char **argv) 
{
	::testing::InitGoogleTest(&argc, argv);
    int r = RUN_ALL_TESTS();

    return r;
}
