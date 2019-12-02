FROM mysql:5.7

RUN \
	echo "character_set_server=utf8\ncollation_server = utf8_general_ci\nsecure_file_priv=\"/\"\ninnodb_log_files_in_group=4\ninnodb_log_file_size=512M\ninnodb_buffer_pool_size = 1G\ninnodb_log_buffer_size = 16777216\nmax_length_for_sort_data=8192\ninnodb_data_file_path=ibdata1:1G:autoextend\ninnodb_file_per_table=ON\ninnodb_file_format=Barracuda\ninnodb_file_format_max=Barracuda\n" >>/etc/mysql/mysql.conf.d/mysqld.cnf
