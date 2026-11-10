<?php
if(!defined('DB_SERVER')){
    require_once("../initialize.php");
}
class DBConnection{

    private $host = DB_SERVER;
    private $username = DB_USERNAME;
    private $password = DB_PASSWORD;
    private $database = DB_NAME;
    private $port;
    
    public $conn;
    
    public function __construct(){

        if (!isset($this->conn)) {
            $this->port = defined('DB_PORT') ? (int)DB_PORT : 3306;
            
            $this->conn = mysqli_init();
            if ($this->conn) {
                $this->conn->options(MYSQLI_OPT_CONNECT_TIMEOUT, 10);
                
                // Cloud providers like Aiven require SSL
                $flags = 0;
                if ($this->host !== '127.0.0.1' && $this->host !== 'localhost') {
                    $this->conn->ssl_set(NULL, NULL, NULL, NULL, NULL);
                    $flags = defined('MYSQLI_CLIENT_SSL_DONT_VERIFY_SERVER_CERT') ? MYSQLI_CLIENT_SSL_DONT_VERIFY_SERVER_CERT : 0;
                }
                
                $connected = @$this->conn->real_connect($this->host, $this->username, $this->password, $this->database, $this->port, NULL, $flags);
                if (!$connected) {
                    // Try without SSL flag if not enforced
                    $connected = @$this->conn->real_connect($this->host, $this->username, $this->password, $this->database, $this->port);
                }
            } else {
                $connected = false;
            }
            
            if (!$connected || $this->conn->connect_error) {
                echo 'Cannot connect to database server (' . htmlspecialchars($this->host) . ':' . $this->port . '): ' . ($this->conn ? htmlspecialchars($this->conn->connect_error) : 'Unknown connection error');
                exit;
            }            
        }    
        
    }
    public function __destruct(){
        if(isset($this->conn) && $this->conn){
            $this->conn->close();
        }
    }
}
?>