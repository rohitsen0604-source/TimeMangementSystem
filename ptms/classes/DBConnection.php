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
            $this->conn = new mysqli($this->host, $this->username, $this->password, $this->database, $this->port);
            
            if (!$this->conn || $this->conn->connect_error) {
                echo 'Cannot connect to database server: ' . ($this->conn ? $this->conn->connect_error : 'error');
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