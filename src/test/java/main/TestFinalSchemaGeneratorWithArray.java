package main;

import java.awt.Desktop;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.swing.JFileChooser;

public class TestFinalSchemaGeneratorWithArray {

	public static void main(String[] args) throws IOException
	{

//		Getting input file from user
		JFileChooser chooser=new JFileChooser();
		chooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
		chooser.showSaveDialog(null);

		String inputpath=chooser.getSelectedFile().getAbsolutePath();
		String filename=chooser.getSelectedFile().getName();
		System.out.println("filename-->"+ filename);

		//		Getting input file as String
		String json= new String( Files.readAllBytes(Paths.get(inputpath)));

		//Script for generating expected schema
		String finalJson="",newWord="", newWordNumber="";



		String splittedNew[]=json.split("\\r?\\n");

		for(int i=0;i<splittedNew.length;i++)
		{
			if(!splittedNew[i].contains(": \""))
			{
				//For array or objects 
				if(!splittedNew[i].contains(":"))
				{
					//Added if block newly for "home" is not converting as ##string
					if(splittedNew[i].contains("\"") && splittedNew[i].contains("\""))
					{
						if(splittedNew[i].endsWith(","))
						{
							splittedNew[i] = "\"##string\""+",";
						}
						else {
							splittedNew[i] = "\"##string\"";
						}

					}
					finalJson += splittedNew[i]+"\n";

				}

				else {

					String[] numString = splittedNew[i].split(":");
					if(!(numString[1].contains(" [") || numString[1].contains(" {")))
					{
						if(numString[1].contains(","))
						{
							String s2Num[]= numString[1].split(",");
							//Added newly for boolean
							if(s2Num[0].contains("true") || s2Num[0].contains("false"))
							{
								s2Num[0]="\"##boolean\"";
								newWordNumber = numString[0]+": "+s2Num[0]+",";
							}
							//For numbers
							else {
								s2Num[0]="\"##number\"";
								newWordNumber = numString[0]+": "+s2Num[0]+",";
							}

						}else {
							//For boolean
							if(numString[1].contains("true") || numString[1].contains("false"))
							{
								numString[1]="\"##boolean\"";
								newWordNumber = numString[0]+": "+ numString[1];
							}else {
								numString[1]="\"##number\"";
								newWordNumber = numString[0]+": "+ numString[1];
							}

						}
						finalJson += newWordNumber+"\n"; 
					}
					else {
						finalJson += splittedNew[i]+"\n";
					}
				}

			}
			//For String 
			else
			{
				String[] str = splittedNew[i].split(": \"");
				if(str[1].equals("\""))
				{
					str[1]="\"##string\"";
					newWord = str[0]+": "+str[1];
				}else {
				String s2[]= str[1].split("\"");
				s2[0]="\"##string\"";
				newWord = str[0]+": "+s2[0];
				if(s2.length==2)
				{
					newWord += s2[1];
				}
				}
				finalJson += newWord+"\n";
			}

			}
		
		System.out.println(finalJson);
		//		To write in output file
		byte[] arr = finalJson.getBytes();

		//		Path for output file
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMdd_HHmmss");
		LocalDateTime now = LocalDateTime.now();
		String timeStemp=dtf.format(now);

		String parentPath=chooser.getSelectedFile().getParent();
//		String outputFilePathName=parentPath+"\\"+filename.split(".txt")[0]+"wholeSchema.json"; --working
		//		Added for creating folder
		String folderName=parentPath+"\\"+filename.replace(".txt", "");
		 File dir = new File(folderName);
	        if (!dir.exists()) dir.mkdirs();
		String outputFilePathName=folderName+"\\"+filename.split(".txt")[0]+"wholeSchema.json";
		Path outputPath  = Paths.get(outputFilePathName);

		// Writing whole schema in output file
		try {
			Files.write(outputPath, arr);
		}catch(Exception e)
		{
		}
		//System.out.println("Whole Schema generated successfully");
		
//		To replace array with names from common data -e.g. below
		
	/*	"contacts": [
		             {
		                 "contactMethod": "EMAIL",
		                 "contactValue": "@wickes.co.uk"
		             },
		             {
		                 "contactMethod": "FAX",
		                 "contactValue": "020 8863 6225"
		             },
		             {
		                 "contactMethod": "PHONE",
		                 "contactValue": "020 8901 2000"
		             }
		         ],
		         
		         Changing to "contacts": "##[] #(commonData.contacts[0])",
		         */
		
		String splittedNewArray[]=finalJson.split("\\r?\\n");
		 String finalArray="";
		 StringBuffer buf = new StringBuffer("");
		 int arrayNumber=0,i=0;
		 int j=0;boolean isArrayEnd=false, firstEntry=false;
		 int indexofStart;int indexofEnd;
		 for( i=arrayNumber;i<splittedNewArray.length;i++)
		 {
			 indexofStart=0;indexofEnd=0;
			 if(splittedNewArray[i].contains("\": [") && !splittedNewArray[i].contains("[]"))
			 {
				if(i!=1) 
				{ 
					if(firstEntry)
				 {
				 int length=buf.length();
				 buf.replace(0, length-1, "");
				 }
				 buf.append(splittedNewArray[i]);
				 String keyName[]= splittedNewArray[i].split("\"");
				 String finalKey=keyName[1].replace("\"", "")+"[0]".replace("       ", "");
				 for( j=i+1;j<splittedNewArray.length;i++)
				 {
				 buf.append(splittedNewArray[j]);
				 indexofStart=splittedNewArray[i].indexOf("\": [");
				 if(splittedNewArray[j].contains("]"))
					{
					  indexofEnd=buf.indexOf("]");
					 String keyValue="    \""+keyName[1]+"\"";
					 buf.replace(indexofStart+1, indexofEnd+1, keyValue+ ": \"##[] #(commonData."+finalKey+")\"");
					 isArrayEnd=true;
					 break;
					}
				 j++;
				
				 }
				 firstEntry=true;
				 finalArray += buf+"\n";
				 i=j;
				
				}else {
					 
					 finalArray += splittedNewArray[i]+"\n";
					 }
			 }else {
			 
			 finalArray += splittedNewArray[i]+"\n";
			 }
			 
		 }
		 System.out.println("*******With Array*****************");
		 System.out.println(finalArray);
		 
//		 Writing json with named arrays in output file
//			To write in output file
			byte[] jsonWithArray = finalArray.getBytes();
//			String arrayoutputFilePathName=parentPath+"\\"+filename.split(".txt")[0]+"schemaWithArray.json"; - working fine
			String arrayoutputFilePathName=folderName+"\\"+filename.split(".txt")[0]+".json";
			Path arrayOutputPath  = Paths.get(arrayoutputFilePathName);

			// Writing whole schema in output file
			try {
				Files.write(arrayOutputPath, jsonWithArray);
			}catch(Exception e)
			{
			}
			
			
//			For writing base schema(only arrays ) 

			 String splittedOnlyArray[]=finalJson.split("\\r?\\n");
			 String finalArrayOnlyOutput="";
			 StringBuffer bufferArray = new StringBuffer("");
			 int arrayNumber1=0,m=0;
			 int n=0;boolean isArrayEnd1=false, firstEntry1=false;
			 for( m=arrayNumber1;m<splittedOnlyArray.length;m++)
			 {
				 if(splittedOnlyArray[m].contains("\": [") && !splittedOnlyArray[m].contains("[]"))
				 {
					 if(i!=1)
					 {
					 if(firstEntry1)
					 {
					 int length=bufferArray.length();
					 bufferArray.replace(0, length-1, "");
					 }
					 bufferArray.append(splittedOnlyArray[m]+"\n");
					 String keyName[]= splittedOnlyArray[m].split("\"");
					 String finalKey=keyName[1].replace("\"", "")+"[0]".replace("       ", "");
					 for( n=m+1;n<splittedOnlyArray.length;m++)
					 {
					 bufferArray.append(splittedOnlyArray[n]+"\n");
					 if(splittedOnlyArray[n].contains("]"))
						{
						 String keyValue="    \""+keyName[1]+"\"";
						 isArrayEnd1=true;
						 break;
						}
					 n++;
					
					 }
					 firstEntry1=true;
					 finalArrayOnlyOutput += bufferArray;
					 m=n;
					 }
					 
				 }else {
				 
					 splittedOnlyArray[m]="";
					 finalArrayOnlyOutput += splittedOnlyArray[m];
				 }
				 
			 }
			 System.out.println("*******With Array*****************");
			 System.out.println(finalArrayOnlyOutput);
			 
			 
//			 Writing sub schema in output file
//				To write in output file
				byte[] onlyArray = finalArrayOnlyOutput.getBytes();
				String onlyArrayoutputFilePathName=folderName+"\\"+filename.split(".txt")[0]+"baseSchema.json";
				System.out.println("Output File path-->"+folderName);
				Path onlyarrayOutputPath  = Paths.get(onlyArrayoutputFilePathName);

				// Writing whole schema in output file
				try {
					Files.write(onlyarrayOutputPath, onlyArray);
				}catch(Exception e)
				{
				}
//		To open output folder
		Desktop.getDesktop().open(new File(folderName));
		
	}

	}


