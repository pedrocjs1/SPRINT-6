SELECT (strftime('%Y', 'now') - strftime('%Y', dob)) - (strftime('%m-%d', 'now') - strftime('%m-%d', dob)) 
FROM cliente;

