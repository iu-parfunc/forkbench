#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#define THREADSTACK 65536

pthread_attr_t  attrs;

void* spawntree(void* pointer)
{
    long* pointer_to_number = (long*)pointer;
    long input = *pointer_to_number;
    
    if (input == 0)
    {
        *pointer_to_number = 1;
        return NULL;
    }
    
    long half1 = input / 2;
    long half2 = half1 + (input % 2) - 1;
    
    pthread_t child;
    
    if (pthread_create(&child, &attrs, spawntree, (void*)&half1) != 0)
    {
        perror("pthread_create");
        *pointer_to_number = 0;
        return NULL;
    }
    spawntree((void*)&half2);
    
    if (pthread_join(child, NULL) != 0)
    {
        perror("pthread_join");
        *pointer_to_number = 0;
        return NULL;
    }
    
    
    *pointer_to_number = half1 + half2;
    return NULL;
}

int main(int argc, char** argv)
{
    long value = 30;
    
    if (argc == 2)
        value = strtol(argv[1], NULL, 0);
    
    pthread_t thread;
    pthread_attr_init(&attrs);
    pthread_attr_setstacksize(&attrs, THREADSTACK);
    
    spawntree((void*)&value);
    
    pthread_attr_destroy(&attrs);
    printf("spawntree # is: %d\n", value);
    return 0;
}
