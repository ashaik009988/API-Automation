package main;

import com.intuit.karate.junit5.Karate;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;


class ExamplesTest {
    
    // this will run all *.feature files that exist in sub-directories
    // see https://github.com/intuit/karate#naming-conventions   
    @Karate.Test
    Karate testAll() {
        return Karate.run().relativeTo(getClass());
    }


    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new FileReader("src/test/java/examples/users/Scenario_9_v2_Knb_Paged_GET.json"));
        String sb = null;
        String file = br.readLine();

        while (file != null) {

            sb = sb+(file)+"\n";
            file = br.readLine();

        }

        System.out.println(sb);
    }



}


   