#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>
#include <fcntl.h>
#define MAX_INPUT 1024 // Max number of characters that the input can support
#define MAX_LIST 100   // Max number of commands to be supported
#define MAX_ARGS 10    // Max number of arguments that a command can support
#define PIPE_DELIM "|"
#define WORD_DELIM " "
// #define REDIRECT_DELIM '>'

struct Command
{
  char *args[MAX_ARGS];
  unsigned numberOfArgs;
};

void parseComm(struct Command *comm, char *string)
{
  char *tokenPtr;
  char *token = __strtok_r(string, WORD_DELIM, &tokenPtr);
  int i = 0;

  while (i < MAX_ARGS && token != NULL)
  {
    comm->args[i] = malloc(sizeof(char) * (strlen(token) + 1));
    strcpy(comm->args[i], token);
    comm->numberOfArgs = comm->numberOfArgs + 1;
    token = __strtok_r(NULL, WORD_DELIM, &tokenPtr);
    i++;
  }
}

int onlySpaces(char *string)
{
  unsigned flag = 0;

  if (string == NULL)
    return flag;

  flag = 1;

  for (int i = 0; i < strlen(string) && flag == 1; i++)
  {
    if (string[i] != ' ')
      flag = 0;
  }

  return flag;
}

void parseCommList(struct Command **commList, char *string, unsigned *numberOfComms)
{
  char *tokenPtr;
  char *token = __strtok_r(string, PIPE_DELIM, &tokenPtr);
  int i = 0;

  while (i < MAX_LIST && token != NULL && !onlySpaces(token))
  {
    commList[i] = malloc(sizeof(struct Command));
    commList[i]->numberOfArgs = 0;

    // Initialize args
    for (int j = 0; j < MAX_ARGS; j++)
      commList[i]->args[j] = NULL;

    parseComm(commList[i], token);

    (*numberOfComms)++;

    token = __strtok_r(NULL, PIPE_DELIM, &tokenPtr);

    i++;
  }
}

void printCommList(struct Command **commList)
{
  int i = 0;

  while (i < MAX_LIST && commList[i] != NULL)
  {
    int j = 0;

    printf("Command arguments: ");

    while (j < MAX_ARGS && commList[i]->args[j] != NULL)
    {
      printf(" %s ", commList[i]->args[j]);
      j++;
    }

    printf("\n");

    printf("Number of arguments: %d\n", commList[i]->numberOfArgs);

    i++;
  }
}

void execute(struct Command *comm, unsigned fd)
{
  __pid_t pid = fork();

  if (pid == 0)
  { // Child process
    if (fd != -1)
    {
      dup2(fd, STDOUT_FILENO);
      close(fd);
    }

    if (execvp(comm->args[0], comm->args) == -1)
    {
      printf("Command not found\n");

      for (unsigned i = 0; i < comm->numberOfArgs; i++)
        free(comm->args[i]);
      free(comm);

      exit(1);
    }
  }
  else
  {
    if (fd != -1)
      close(fd);
    waitpid(pid, NULL, 0);
  }
}

void executePipe(struct Command **commList, unsigned numberOfComms, unsigned fd)
{
  int fds[numberOfComms - 1][2];

  for (int i = 0; i < numberOfComms - 1; i++)
    pipe(fds[i]);

  for (int i = 0; i < numberOfComms; i++)
  {
    __pid_t pid = fork();

    if (pid == 0)
    { // Child process
      if (i > 0)
        dup2(fds[i - 1][0], STDIN_FILENO);

      if (i < numberOfComms - 1)
        dup2(fds[i][1], STDOUT_FILENO);

      if (i == numberOfComms - 1)
      {
        if (fd != -1)
        {
          dup2(fd, STDOUT_FILENO);
          close(fd);
        }
      }

      for (int j = 0; j < numberOfComms - 1; j++)
      {
        close(fds[j][0]);
        close(fds[j][1]);
      }

      if (execvp(commList[i]->args[0], commList[i]->args) == -1)
      {
        printf("Command not found\n");

        for (int j = 0; j < numberOfComms; j++)
        {
          for (unsigned k = 0; k < commList[j]->numberOfArgs; k++)
            free(commList[j]->args[k]);
          free(commList[j]);
        }

        exit(1);
      }
    }
  }

  // Parent process
  for (int i = 0; i < numberOfComms - 1; i++)
  {
    close(fds[i][0]);
    close(fds[i][1]);
  }

  for (int i = 0; i < numberOfComms; i++)
    wait(NULL);

  if (fd != -1)
    close(fd);
}

void clean(struct Command **commList, unsigned numberOfComms)
{
  for (int i = 0; i < numberOfComms; i++)
  {
    for (int j = 0; j < commList[i]->numberOfArgs; j++)
      free(commList[i]->args[j]);
    free(commList[i]);
    commList[i] = NULL;
  }
}

void cd(struct Command *comm)
{
  // TODO: check if arguments are incorrect.
  chdir(comm->args[1]);
}

void removeExtraRedirects(char *string)
{
  // Returns a pointer to the first occurrence of the character in string
  char *start = strchr(string, '>');

  // Returns a pointer to the last occurrence of character in string
  char *end = strrchr(string, '>');

  if (start != end)
  {
    for (char *p = start; p < end; p++)
    {
      *p = ' ';
    }
  }
}

void parseRedirect(char *string, char **filePath, struct Command **commList, unsigned *numberOfComms)
{
  removeExtraRedirects(string);

  char *tokenPtr;
  char *token = __strtok_r(string, ">", &tokenPtr);

  if (token != NULL)
    parseCommList(commList, token, numberOfComms);

  token = __strtok_r(NULL, ">", &tokenPtr);
  if (token != NULL)
  {
    char *wordPtr;
    char *word = __strtok_r(token, " ", &wordPtr);
    *filePath = malloc(sizeof(char) * (strlen(word) + 1));
    strcpy(*filePath, word);
  }
}

void parseInput(char *string, char **filePath, struct Command **commList, unsigned *numberOfComms)
{
  parseRedirect(string, filePath, commList, numberOfComms);
}

int main()
{
  char buffer[MAX_INPUT];

  struct Command *commList[MAX_LIST];
  unsigned numberOfComms;

  unsigned exitFlag = 0;

  char *filePath;
  unsigned fd;

  do
  {
    numberOfComms = 0;
    filePath = NULL;
    fd = -1;

    // Initialize commList
    for (int i = 0; i < MAX_LIST; i++)
      commList[i] = NULL;

    printf(">> ");

    fgets(buffer, MAX_INPUT, stdin);
    buffer[strcspn(buffer, "\n")] = '\0';

    parseInput(buffer, &filePath, commList, &numberOfComms);

    if (filePath != NULL)
      fd = open(filePath, O_WRONLY | O_CREAT | O_TRUNC, 0644);

    if (numberOfComms == 1)
    {
      if (strcmp(commList[0]->args[0], "exit") == 0)
      {
        printf("Bye!\n");
        exitFlag = 1;
      }
      else if (strcmp(commList[0]->args[0], "cd") == 0)
        cd(commList[0]);
      else
        execute(commList[0], fd);

      if (filePath != NULL)
        free(filePath);
      clean(commList, numberOfComms);
    }
    else if (numberOfComms > 1)
    {
      if (strcmp(commList[0]->args[0], "exit") == 0)
      {
        printf("Bye!\n");
        exitFlag = 1;
      }
      else
        executePipe(commList, numberOfComms, fd);

      if (filePath != NULL)
        free(filePath);
      clean(commList, numberOfComms);
    }

  } while (!exitFlag);

  return 0;
}