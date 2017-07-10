#!/bin/sh

dialog --title "Osom" --clear --menu "----------Tools----------" 0 0 0 1 "Worker Partial" 2 "Generate All" 3 "Clear cache" 4 "Solr Import" 5 "Solr Update" 6 "Schema Updater" 7 "Clear logs" 8 "Worker" 9 "Start" 2>temp


# OK is pressed
if [ "$?" = "0" ]
    then
    _return=$(cat temp)

        # 1 /Run worker partial
        if [ "$_return" = "1" ]
            then
            clear
            php alice/worker/Worker.php partial
            echo "Worker Partial Successfull!! Bamm!!";
        fi

         # 2 /generate all
        if [ "$_return" = "2" ]
            then
            clear
            echo "Runing  generate all...";     
            php tools/generate_all.php
        fi

        # /Start Solr help!!
        #if [ "$_return" = "3" ]
        # then
        #   cd solr/jetty/ && sudo java -jar start.jar &
        #   SIGINT

        #fi

         # 3 /Clear zend cache
        if [ "$_return" = "3" ]
            then
            clear
            echo "Clearing Cache...";
            sudo rm -rf bob/data/cache/zend_cache---*
        fi

        # 4 /Solr import
        if [ "$_return" = "4" ]
            then
            clear
            echo "Runing Solr Import...";
            sudo -u www-data php bob/cli/index.php --env=dev --module=solr --controller=import --action=import
        fi

        # 5 /Solr update
        if [ "$_return" = "5" ]
            then
            clear
            echo "Runing Solr Update...";
            sudo -u www-data php bob/cli/index.php --env=dev --module=solr --controller=import --action=update
        fi

        # 6 /Schema updater
        if [ "$_return" = "6" ]
            then
            clear
            echo "Runing DBTables...";
            sudo php bob/cli/index.php --env=dev --module=maintenance --controller=schema-updater --action=dbtable
        fi

        # 7 /Clear logs
        if [ "$_return" = "7" ]
            then
            clear
            echo "Clearing Logs...";
            sudo rm -rf bob/data/logs/*
        fi

        # 8 /Clear logs
        if [ "$_return" = "8" ]
            then
            clear
            echo "Worker Full...";
            sudo php alice/worker/Worker.php
        fi

        # 9 /Start run all
        if [ "$_return" = "9" ]
            then
            sudo service nginx restart && php tools/generate_all.php && php alice/worker/Worker.php && cd solr/jetty/ && sudo java -jar start.jar
        fi

# Cancel
else
    clear
    echo "Cancel Bamm!"
fi

# remove the temp file
rm -f temp
