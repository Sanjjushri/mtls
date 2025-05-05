import javax.net.ssl.*;
import java.io.*;
import java.security.KeyStore;
import java.net.URL;
import java.net.HttpURLConnection;

public class MTLSClient {
    public static void main(String[] args) throws Exception {
        // Load client keystore
        KeyStore keyStore = KeyStore.getInstance("JKS");
        keyStore.load(new FileInputStream("client.keystore"), "changeit".toCharArray());

        // Load client truststore
        KeyStore trustStore = KeyStore.getInstance("JKS");
        trustStore.load(new FileInputStream("client.truststore"), "changeit".toCharArray());

        // Initialize KeyManagerFactory with client keystore
        KeyManagerFactory kmf = KeyManagerFactory.getInstance("SunX509");
        kmf.init(keyStore, "changeit".toCharArray());

        // Initialize TrustManagerFactory with client truststore
        TrustManagerFactory tmf = TrustManagerFactory.getInstance("SunX509");
        tmf.init(trustStore);

        // Initialize SSLContext with key and trust managers
        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(kmf.getKeyManagers(), tmf.getTrustManagers(), null);

        // Open HTTPS connection to the server
        URL url = new URL("https://localhost:5001/");
        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
        conn.setSSLSocketFactory(sslContext.getSocketFactory());

        // Read response
        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String inputLine;
        while ((inputLine = in.readLine()) != null)
            System.out.println(inputLine);
        in.close();
    }
}
