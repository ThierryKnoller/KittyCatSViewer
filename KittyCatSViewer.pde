/*
KittyCatSViewer version 0.1
By Thierry Knoller ( secondlife:///app/agent/a00105a4-534e-4269-86ae-0186d672c668/about )
Released under the GNU AGPL-3.0 License. 
*/

import java.net.URI;
import java.net.URISyntaxException;
import java.awt.datatransfer.*;
import java.awt.Toolkit;

String input="";
String lastinput;
String lines[];

String fur;
String eyecolor;
String eyeshape;
String pupil;
String ear;
String whiskercolor;
String whiskershape;

String shadowimgurl;
String furimgurl;
String eyeimgurl;
String whiskerimgurl;

PImage shadowimg;
PImage furimg;
PImage eyeimg;
PImage whiskerimg;

Clipboard clipboard=Toolkit.getDefaultToolkit().getSystemClipboard();

void setup()
{
  size(400, 540);
  textAlign(CENTER, CENTER);
  fill(255, 100, 100);
}

void draw()
{
  try
  {
    input=(String)clipboard.getData(DataFlavor.stringFlavor);
    if(!input.equals(lastinput))
    {
      background(200);
      lastinput=input;
      surface.setTitle("Getting traits...");
      getStrings();
      getImages();
      surface.setTitle("Assembling image...");
      image(shadowimg, 0, 0);
      image(furimg, 0, 0);
      image(eyeimg, 0, 0);
      image(whiskerimg, 0, 0);
      surface.setTitle("Assembling image...Done.");
    }
  }
  catch(MissingTraitException e)
  {
    background(200);
    text("ERROR: " + e.getMessage(), 20, 20, width-20, height-20);
    println("ERROR: " + e.getMessage());
  }
  catch(MissingImageException e)
  {
    background(200);
    text("ERROR: " + e.getMessage(), 20, 20, width-20, height-20);
    println("ERROR: " + e.getMessage());
  }
  catch(Exception e)
  {
    background(200);
    text("ERROR: Unknown error.", 20, 20, width-20, height-20);
    println("ERROR: Unknown error.");
    e.printStackTrace();
  }
}

class MissingTraitException extends Exception
{
  MissingTraitException(String trait)
  {
    super("No information for \"" + trait + "\" could not be found. Please make sure you copied everything correctly.");
  }
}

class MissingImageException extends Exception
{
  MissingImageException(String img)
  {
    super("The image at \"" + img + "\" could not be found. Please make sure you copied everything correctly.");
  }
}

void getImages() throws MissingImageException, URISyntaxException
{
  fur=fur + ".png";
  eyecolor=eyecolor.toLowerCase() + ".png";
  whiskercolor=whiskercolor + ".png";
  shadowimgurl=new URI("https", "kittycats.ws", "/online/images/ears/" + ear + "_SHADOW.png", null).toString();
  furimgurl=new URI("https", "kittycats.ws", "/online/images/ears/" + ear + "/" + fur, null).toString();
  eyeimgurl=new URI("https", "kittycats.ws", "/online/images/eyes/" + eyeshape + "_" + pupil + "/" + eyecolor, null).toString();
  whiskerimgurl=new URI("https", "kittycats.ws", "/online/images/whiskers/" + whiskershape + "/" + whiskercolor, null).toString();
  //println(shadowimgurl); //DEBUG
  surface.setTitle("Loading shadow image...");
  shadowimg=loadImage(shadowimgurl);
  if(shadowimg==null)throw new MissingImageException(shadowimgurl);
  //println(furimgurl); //DEBUG
  surface.setTitle("Loading fur image...");
  furimg=loadImage(furimgurl);
  if(furimg==null)throw new MissingImageException(furimgurl);
  //println(eyeimgurl); //DEBUG
  surface.setTitle("Loading eye image...");
  eyeimg=loadImage(eyeimgurl);
  if(eyeimg==null)throw new MissingImageException(eyeimgurl);
  //println(whiskerimgurl); //DEBUG
  surface.setTitle("Loading whisker image...");
  whiskerimg=loadImage(whiskerimgurl);
  if(whiskerimg==null)throw new MissingImageException(whiskerimgurl);
}

void getStrings() throws MissingTraitException
{
  fur="";
  eyecolor="";
  eyeshape="";
  pupil="";
  ear="";
  whiskercolor="";
  whiskershape="";
  lines=split(input , "\n");
  for(int i=0; i<lines.length; i++)
  {
    if(lines[i].length()>=4)
    {
      if(lines[i].substring(0, 4).equals("Fur:"))
      {
        fur=lines[i].substring(5, lines[i].length());
      }
      else if(lines[i].substring(0, 5).equals("Eyes:"))
      {
        eyecolor=lines[i].substring(6, lines[i].indexOf("(")-1);
        eyeshape=lines[i].substring(lines[i].indexOf("(")+8, lines[i].indexOf("|")-1);
        pupil=lines[i].substring(lines[i].indexOf("|")+9, lines[i].length()-1);
      }
      else if(lines[i].substring(0, 5).equals("Ears:"))
      {
        ear=lines[i].substring(6, lines[i].length());
      }
      else if(lines[i].substring(0, 9).equals("Whiskers:"))
      {
        whiskercolor=lines[i].substring(10, lines[i].indexOf("(")-1);
        whiskershape=lines[i].substring(lines[i].indexOf("(")+8, lines[i].length()-1);
      }
    }
  }
  if(fur.length()==0)throw new MissingTraitException("Fur:");
  if(eyecolor.length()==0)throw new MissingTraitException("Eyes:");
  if(ear.length()==0)throw new MissingTraitException("Ears:");
  if(whiskercolor.length()==0)throw new MissingTraitException("Whiskers:");
}
