import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
java.nio.file.InvalidPathException
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Arrays;
import java.util.List;

//Dom: document object model
public class Xml_JdbcDemo {
    public static void main(String[] args) throws Exception {
        //1. Load driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://127.0.0.1:3306/dbxml";
        String usename = "root";
        String password = "";
        Connection conn = DriverManager.getConnection(url,usename,password);

        //crate table accrding to the XML file
        conn.createStatement().execute("create table books(\n"+
                "id integer primary key auto_increment,\n"+
                "book_id varchar (30) not null unique, \n"+
                "author varchar(100) not null,\n"+
                "title varchar(50) not null,\n"+
                "genre varchar(25) not null,\n"+
                "price float not null,\n"+
                "publish_date date not null,\n"+
                "descriptor text not null\n" +")");

        //XML loading
        File file = new File("src/Book.xml");
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document xmlDoc = builder.parse(file);

        XPath xPath = XPathFactory.newInstance().newXPath();
        Object res = xPath.evaluate("/catalog/book",xmlDoc, XPathConstants.NODESET);

        NodeList nodeList = (NodeList) res;

        PreparedStatement stmt = conn.prepareStatement("INSERT INTO books" +
                "(book_id,author,title,genre,price,publish_date,descriptor) VALUES(" +
                "?,?,?,?,?,str_to_date(?,'%Y-%m-%d'),?)");

        //save to db
        for(int i = 0;i < nodeList.getLength();i++){
            Node node = nodeList.item(i);
            List<String> columns = Arrays.asList(getAttrValue(node,"id"),
                    (getTextContent(node,"author"),
                    (getTextContent(node,"title"),
                    (getTextContent(node,"genre"),
                    (getTextContent(node,"price"),
                    (getTextContent(node,"publish_date"),
                    (getTextContent(node,"description"));
                //Lấy giá trị của bẳng ghi
            for (int n = 0; n < columns.size();n++){
                stmt.setString(n+1,columns.get(n));
            }
            stmt.executeUpdate();
            System.out.println("Import xml data success");
        }
    }

    //hàm đọc file xml
    static private String getAttrValue(Node node, String attrName){
        if (!node.hasAttributes()) return "";
        NamedNodeMap nmap = node.getAttributes();
        if (nmap == null) return "";
        Node n = nmap.getNamedItem(attrName);
        if (n == null) return "";

        return n.getNodeValue();
    }//lấy ra được các giá trị thuộc tính ở trong node
    static private void getTextContent(Node parentNode, String childNode){
        NodeList nList = parentNode.getChildNodes();
        for (int i = 0; i < nList.getLength();i++){
            Node n = nList.item(i);
            String name = n.getNodeName();
            if (name!=null && name.equals(childNode)){
                return n.getTextContent();
            }
            return "";
        }
    }

