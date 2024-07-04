package main;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.intuit.karate.core.KarateParser;

import javax.naming.Context;
import java.io.*;
import java.nio.charset.Charset;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.Random;

public class CustomDefs {

	// Java program generate a random AlphaNumeric String
	public static String currentModulePath = null;
	public static String getAlphaNumericString(int n) {

		// chose a Character random from this String
		String AlphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "0123456789" + "abcdefghijklmnopqrstuvxyz";

		// create StringBuffer size of AlphaNumericString
		StringBuilder sb = new StringBuilder(n);

		for (int i = 0; i < n; i++) {

			// generate a random number between
			// 0 to AlphaNumericString variable length
			int index
					= (int) (AlphaNumericString.length()
					* Math.random());

			// add Character one by one in end of sb
			sb.append(AlphaNumericString
					.charAt(index));
		}

		return sb.toString();
	}

	public static String getRandomTransactionNumber() {
		int number = (int) (Math.random() * (888888 - 999999) + 888888);
		return number + "";
	}


	public static String getRandomTillReceiptNumber() {
		int number = (int) (Math.random() * (0000 - 9999) + 0000);
		return number + "";
	}

	public static String getRandomGpid() {
		long number1 = (long) Math.floor(Math.random() * 9_000_000_000L) + 1_000_000_000L;
		return number1 + "";
	}

	public static String getTodayDate() {
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDateTime now = LocalDateTime.now();
		return now.format(dtf).toString();
	}

	public static String getTodayDateTime() {
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		LocalDateTime now = LocalDateTime.now();
		String dateTime = now.toString().substring(0, 23) + "Z";
		return dateTime;
	}

	public static String getRangeName() {
		int leftLimit = 97; // letter 'a'
		int rightLimit = 122; // letter 'z'
		int targetStringLength = 10;
		Random random = new Random();
		StringBuilder buffer = new StringBuilder(targetStringLength);
		for (int i = 0; i < targetStringLength; i++) {
			int randomLimitedInt = leftLimit + (int)
					(random.nextFloat() * (rightLimit - leftLimit + 1));
			buffer.append((char) randomLimitedInt);
		}
		String generatedString = buffer.toString();
		return generatedString;
	}

	public static void setModulePath(String featureFileName) throws IOException {
		String userDir = System.getProperty("user.dir");
		Path path = Paths.get(userDir + "/src/test/java/main");

		Optional<String> optStr = Optional.of("");
		StringBuilder modulePath = new StringBuilder();

		List<Path> pathList = Files.walk(path, 1)
				.filter(Files::isDirectory)
				.collect(Collectors.toList());

		pathList.remove(0);

		for (Path currentPath : pathList) {

			Files.walk(Paths.get(currentPath.toUri()))
					.filter(Files::isRegularFile)
					.forEach(path2 -> {
						String name = path2.getFileName().toString();
						if (name.equals(featureFileName)) {
							optStr.ifPresent(s -> modulePath.append(currentPath));
						}
					});
		}
		currentModulePath = modulePath.toString();
	}
	public static void write(Object data) throws IOException, IOException {

		String filePath = currentModulePath + "/data/" + "commonData.json";

		File resultFile = new File(filePath);
		FileWriter writer = new FileWriter(resultFile);
		BufferedWriter bw = new BufferedWriter(writer);
		ObjectMapper Obj = new ObjectMapper();

		// Converting the Java object into a JSON string
		String jsonStr = Obj.writeValueAsString(data);
		// Displaying Java object into a JSON string
		System.out.println(jsonStr);

		bw.write(jsonStr);
		bw.close();

	}

	public static void temporaryWrite(Object data,String filename) throws IOException, IOException {

		String filePath = "src/test/java/main/salesAPI"+ "/data/Output/"+filename+".json";

		File resultFile = new File(filePath);
		FileWriter writer = new FileWriter(resultFile);
		BufferedWriter bw = new BufferedWriter(writer);
		ObjectMapper Obj = new ObjectMapper();

		// Converting the Java object into a JSON string
		String jsonStr = Obj.writeValueAsString(data);
		// Displaying Java object into a JSON string
		System.out.println(jsonStr);

		bw.write(jsonStr);
		bw.close();

	}

	public static String readCommonData(String featureFileName) throws IOException, IOException {

		setModulePath(featureFileName);
		String filePath = currentModulePath + "/data/" + "commonData.json";
		FileInputStream fstream = new FileInputStream(filePath);
		BufferedReader br = new BufferedReader(new InputStreamReader(fstream));
		String dataString = "";
		String newLine;
		while ((newLine = br.readLine()) != null) {
			dataString = dataString + newLine;
		}
		return dataString.toString();

	}

}


