package main.salesAPI;

import com.intuit.karate.junit5.Karate;
import com.intuit.karate.junit5.Karate.Test;


class Runner {
    
    @Test
    Karate testUsers() {

        return Karate.run("ProductService_Positive").relativeTo(getClass());
    }

}
