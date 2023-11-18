#include <winsock.h>
#include <stdio.h>
#include <winerror.h>

#pragma comment(lib, "ws2_32.lib")

#define BUFLEN 256
#define PORT 8829

int main() 
{
    int iResult;
    WSADATA wsaData;

    SOCKET SendSocket = INVALID_SOCKET;
    struct sockaddr_in RecvAddr; 

    int slen, recv_len;
    char buf[BUFLEN];
    memset((void*)&buf, 0, BUFLEN);
    *(int *)(&buf[0]) = 256;
    buf[4] = 'W';
    buf[5] = 'a';
    buf[6] = 'l';
    buf[7] = 'l';
    buf[8] = 'K';
    buf[9] = 'i';
    buf[10] = 'n';
    buf[11] = 'g';
    *(int *)(&buf[12]) = 1;
    buf[17] = 'H';
    buf[18] = 'i';

    // Initialize WinSock 
    iResult = WSAStartup(MAKEWORD(2, 2), &wsaData);
    if (iResult != NO_ERROR) {
        printf("WSAStartup failed with error: %d\n", iResult);
        return EXIT_FAILURE;
    }

    // Create a socket for sending data
    SendSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (SendSocket == INVALID_SOCKET) {
        printf("Socket failed with error: %ld\n", WSAGetLastError());
        WSACleanup();
        return EXIT_FAILURE;
    }

    RecvAddr.sin_family = AF_INET;
    RecvAddr.sin_port = htons(PORT);
    RecvAddr.sin_addr.s_addr = inet_addr("192.168.1.255");

    // Sendig a datagram to the receiver
    printf("Sending a datagram to the receiver\n");
    iResult = sendto(SendSocket, buf, BUFLEN, 0, (SOCKADDR *)& RecvAddr, sizeof(RecvAddr));
    if (iResult == SOCKET_ERROR) {
        printf("Sendto failed with error: %d\n", WSAGetLastError());
        closesocket(SendSocket);
        WSACleanup();
        return EXIT_FAILURE;
    }

    // iResult = shutdown(SendSocket, SD_SEND);
    // if (iResult == SOCKET_ERROR) {
    //     printf("shutdown failed: %d\n", WSAGetLastError());
    //     closesocket(SendSocket);
    //     WSACleanup();
    //     return EXIT_FAILURE;
    // }

    char recvBuf[BUFLEN];
    memset((void *) &recvBuf, 0, BUFLEN);

    // char host[256];
    // char *IP;
    // struct hostent *host_entry;
    // int hostname;

    // hostname = gethostname(host, sizeof(host));
    // host_entry = gethostbyname(host);
    // IP = inet_ntoa(*((struct in_addr*) host_entry->h_addr_list[0]));
    // printf("HOST: %s IP: %s\n", host, IP);

    struct sockaddr_in SendAddr, ServerRecvAddr;
    int addrServerLen = sizeof(ServerRecvAddr);
    int addrLen = sizeof(SendAddr);
    int local_port;
    char *ip;
    iResult = getsockname(SendSocket, (struct sockaddr *)& SendAddr, &addrLen);
    if (iResult == 0 && SendAddr.sin_family == AF_INET && addrLen == sizeof(SendAddr)) {
        ip = inet_ntoa(SendAddr.sin_addr);
        local_port = ntohs(SendAddr.sin_port);
    } else {
        printf("getsockname failed with error: %d\n", WSAGetLastError());
        WSACleanup();
        return EXIT_FAILURE;
    }
    printf("RecvSocket: ip: %s port: %d\n", ip, local_port);

    // iResult = bind(SendSocket, (SOCKADDR *)& SendAddr, addrLen);
    // if (iResult == SOCKET_ERROR) {
    //     printf("bind failed with error %d\n", WSAGetLastError());
    //     return EXIT_FAILURE;
    // }

    printf("receiving datagrams...\n");
    iResult = recvfrom(SendSocket, recvBuf, BUFLEN, 0, (SOCKADDR *)& ServerRecvAddr, &addrServerLen);
    if (iResult == SOCKET_ERROR) {
        printf("recvfrom failed with error %d\n", WSAGetLastError());
    }

    ip = inet_ntoa(ServerRecvAddr.sin_addr);
    local_port = ntohs(ServerRecvAddr.sin_port);
    printf("ServerSocket: ip: %s port: %d\n", ip, local_port);
    printf("Buffer recieved from server:\n");
    for(int i = 0; i < BUFLEN; i ++) {
        printf("%c", recvBuf[i]);
    }
    printf("\n");

    // Close socket
    printf("Finished sending. Closing socket\n");
    iResult = closesocket(SendSocket);
    if (iResult == SOCKET_ERROR) {
        printf("Closesocket failed with error: %d\n", WSAGetLastError());
        WSACleanup();
        return EXIT_FAILURE;
    }

    // Clean up and quite
    printf("Exiting.\n");
    WSACleanup();
    return EXIT_SUCCESS;
}