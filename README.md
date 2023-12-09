#### A small bash script to find top cPanel accounts with files that larger than you specified size and send them as list to a Mattermost channel. This is useful for shared hosting environments and maintain the storage size. 

 * Create a directory for store txt files and script itself. For example, ```path/to/disk_abusers/``` 
 * Make sure that your script has the appropriate executable permission ```chmod +x /path/to/disk_abusers/script.sh```
 * Copy the Webhook URL and Channel name from the Mattermost App created into the WEBHOOK_URL and CHANNEL portions of the script.
 * You can change the ```-size +1G```  as you wish or ```head -n10``` for searching accounts more than 10. 
 * Add a cron job if you want to receive reports continuously. For example, ```0 11 * * * /path/to/disk_abusers/find_disk_abusers.sh > /dev/null 2>&1``` This way, scripts runs every day at 11:00 PM