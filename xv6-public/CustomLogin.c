#include "types.h"
#include "user.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "fcntl.h"

char * user_name_list[10];
char * user_password_list[10];

void read_user_list(){
    
    //malloc으로 메모리할당
    for(int i=0;i<10;i++){
        user_name_list[i] = (char *)malloc(20);
        user_password_list[i] = (char *)malloc(20);
        memset(user_name_list[i],0,sizeof(char)*20);
        memset(user_password_list[i],0,sizeof(char)*20);
    }


    //파일이 존재하지 않을때
    int fd;
    //struct stat st;
    int read_count;
    
    if((fd = open("userlist.txt", O_RDWR))<0){
        close(fd);
        fd = open("userlist.txt", O_CREATE|O_RDWR);
        printf(1,"No usertable. Creat...\n");
        strcpy(user_name_list[0],"root\n");
        strcpy(user_password_list[0],"1234\n");
        for(int i=0;i<10;i++){
            printf(1,"%s%s",user_name_list[i],user_password_list[i]);
            write(fd,user_name_list[i],sizeof(char)*20);
            write(fd,user_password_list[i],sizeof(char)*20);
        }
         
    }else{
        for(int i=0;;i++)
        {
            //읽기
            if((read_count = read(fd,user_name_list[i],20))<=0) break;
            if((read_count = read(fd,user_password_list[i],20))<=0) break;
        }
    }
    close(fd);
}


//login 가능 여부 확인
int check(char *id, char *password) {
    for(int i = 0 ; i < 10 ; i++) {
        printf(1,"%s%s",id,user_name_list[i]);
        if(!strcmp(id, user_name_list[i]) && !strcmp(password, user_password_list[i])) return 1;
    }
    return 0;
}


int main(void){
    char *id = (char *)malloc(20);
    char *password = (char *)malloc(20);

    read_user_list();

    while(1){
        //초기화
        memset(id,0,sizeof(char)*20);
        memset(password,0,sizeof(char)*20);

        //id입력
        printf(1, "Username : ");
        id = gets(id , 20);

        //password 입력
        printf(1, "Password : ");
        password = gets(password , 20);

        // \n제거
        //id[strlen(id) - 1] = 0; 
        //password[strlen(password) - 1] = 0;
    

        if(check(id,password)){
          int pid = fork();
          if(pid < 0 ){
            printf(1, "fork failed\n");
            exit();
          }
          if(pid == 0 ){
			printf(1,"Welcom %s\n",id);
            exec("sh", &id);
            printf(1, "exec sh failed\n");
            exit();
          }
          else{
            wait();
          }
        }

        else{
          printf(1, "Login Fail\n");
        }
    }
    //malloc메모리 해제
    free(id);
    free(password);
    for(int i=0;i<10;i++){
        free(user_name_list[i]);
        free(user_password_list[i]);
    }

    return 0;
}
