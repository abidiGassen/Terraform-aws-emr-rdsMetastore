[
  {
    "Classification": "hadoop-env",
    "Configurations": [
      {
        "Classification": "export",
        "Properties": {
          "JAVA_HOME": "/etc/alternatives/jre"
        }
      }
    ],
    "Properties": {}
  },
  {
    "Classification": "spark-env",
    "Configurations": [
      {
        "Classification": "export",
        "Properties": {
          "JAVA_HOME": "/etc/alternatives/jre"
        }
      }
    ],
    "Properties": {}
  },
  {
    "Classification": "hive-site",
    "Properties": {
      "javax.jdo.option.ConnectionURL": "jdbc:mysql://${hive_metastore_address}:3306/${hive_metastore_name}?createDatabaseIfNotExist=true",
      "javax.jdo.option.ConnectionDriverName": "org.mariadb.jdbc.Driver",
      "javax.jdo.option.ConnectionUserName": "${hive_metastore_user}",
      "javax.jdo.option.ConnectionPassword": "${hive_metastore_pass}",     
      "hive.stats.autogather": "${hive_stats_autogather}"
    }
  }
]