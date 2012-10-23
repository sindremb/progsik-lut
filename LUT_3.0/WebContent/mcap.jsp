<%@ page import="java.util.*" %>
<%@ page import="java.io.*" 
%><%@ page import="java.awt.*"
%><%@ page import="java.awt.image.*"
%><%@ page import="javax.imageio.ImageIO"
%><%@ page import="java.util.*"
%>
<%
	Random rdm1=new Random();
	Random rdmop=new Random();
	//Random rdm2=new Random();
	int num1=rdm1.nextInt(10);
	int num2=rdm1.nextInt(10);
	int num3=rdm1.nextInt(10);
	int op1=rdmop.nextInt(2);
	int op2=rdmop.nextInt(2);
	int res=0;
	String mcap;
		while(num1==0)
			{
				num1=rdm1.nextInt(10);	
	
		}
		while(num2==0)
			{
				num2=rdm1.nextInt(10);
	
		}
		while(num3==0)
			{
				num3=rdm1.nextInt(10);
	
		}
		while(op1==op2)
			{
				op2=rdmop.nextInt(2);
		}
	out.print(num1);
	mcap=Integer.toString(num1);
		if(op1==0)
			{
			//out.print(" + ");
			mcap=mcap+" + ";
		}
		else if(op1==1)
			{
			//out.print(" * ");
			mcap=mcap+" x ";
		}
	//out.print("(");
	//out.print(num2);
	mcap=mcap+" ( ";
	mcap=mcap+Integer.toString(num2);
		if(op2==0)
			{
				//out.print(" + ");
				mcap=mcap+" + ";
		}
		else if(op2==1)
			{
				//out.print(" * ");
					mcap=mcap+" x ";
		}
	//out.print(num3);
	mcap=mcap+Integer.toString(num3);
	
	out.print(")");
	mcap=mcap+" ) ";
		if(op1==0 && op2==0)
			{
				res=num1+(num2+num3);
			}
		else if(op1==0 && op2==1)
			{
				res=num1+(num2*num3);
			}
		else if(op1==1 && op2==0)
			{
				res=num1*(num2+num3);
			}	
		else if(op1==1 && op2==1)
			{
				res=num1*(num2*num3);
			}
//out.print("<br>"+res);
//out.print("mcap="+mcap);
String rstr=Integer.toString(res);
session.setAttribute("key",rstr);
%>
<%
int width=150;
int height=40;

Color background = new Color(204,204,204);

Color fbl = new Color(0,100,0);

Font fnt=new Font("SansSerif",1,14);

BufferedImage cpimg =new BufferedImage(width,height,BufferedImage.TYPE_INT_RGB);

Graphics g = cpimg.createGraphics();

g.setColor(background);

g.fillRect(0,0,width,height);

g.setColor(fbl);

g.setFont(fnt);

g.drawString(mcap,30,25);

g.setColor(background);

g.drawLine(25,20,120,20);

//g.drawLine(25,22,75,22);

response.setContentType("image/jpeg");

OutputStream strm = response.getOutputStream();

ImageIO.write(cpimg,"jpeg",strm);
strm.close();
%>

