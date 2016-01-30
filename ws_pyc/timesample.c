#include "time.h"
#include "stdio.h"
int main(void)
{
	struct tm *local;
	struct tm tm1;
	time_t t;
	t=time(NULL);
	local=localtime(&t);
	printf("Local hour is: %d\n",local->tm_hour);
	local=gmtime(&t);
	printf("UTC hour is: %d\n",local->tm_hour);
	mktime(&tm1);
	printf("UTC hour is: %d, %d\n",tm1.tm_hour, tm1.tm_year);
	return 0;
}

