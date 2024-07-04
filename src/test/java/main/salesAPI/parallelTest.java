package main.salesAPI;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;


import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class parallelTest {

    @Test
    void testParallel() {

    	Results results = Runner.path("classpath:examples\\users").parallel(1);
       
        /* Results results = Runner.parallel(getClass(),5); */
    	assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
    
    
    
    
    
    
}
