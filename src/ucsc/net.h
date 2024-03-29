/* Net.h some stuff to wrap around net communications. 
 *
 * This file is copyright 2002 Jim Kent, but license is hereby
 * granted for all use - public, private or commercial. */


#ifndef NET_H
#define NET_H

#include "linefile.h"
#include "dystring.h"

#define DEFAULTCONNECTTIMEOUTMSEC 10000  /* default connect timeout for tcp in milliseconds */
#define DEFAULTREADWRITETTIMEOUTSEC 120  /* default read/write timeout for tcp in seconds */
#define MAXURLSIZE 4096 /* maximum size in characters for a URL, but also see the struct netParsedUrl definition */


int setReadWriteTimeouts(int sd, int seconds);
/* Set read and write timeouts on socket sd 
 * Return -1 if there are any errors, 0 if successful. */

/* add a failure to connFailures[]
 *  which can save time and avoid more timeouts */
int netConnect(char *hostName, int port);
/* Start connection with a server having resolved port. Return < 0 if error. */

int netMustConnect(char *hostName, int port);
/* Start connection with server or die. */

int netAcceptingSocketFrom(int port, int queueSize, char *host);
/* Create a socket that can accept connections from a 
 * IP address on the current machine if the current machine
 * has multiple IP addresses. */

int netWaitForData(int sd, int microseconds);
/* Wait for descriptor to have some data to read, up to given number of
 * microseconds.  Returns amount of data there or zero if timed out. */

void netBlockBrokenPipes();
/* Make it so a broken pipe doesn't kill us. */

ssize_t netReadAll(int sd, void *vBuf, ssize_t size);
/* Read given number of bytes into buffer.
 * Don't give up on first read! */

char *netGetString(int sd, char buf[256]);
/* Read string into buf and return it.  If buf is NULL
 * an internal buffer will be used. Print warning message
 * and return NULL if any problem. */

char *netGetLongString(int sd);
/* Read string up to 64k and return it.  freeMem
 * the result when done.  Print warning message and
 * return NULL if any problem. */

char *netGetHugeString(int sd);
/* Read string up to 4 gig and return it.  freeMem
 * the result when done.  Print warning message and
 * return NULL if any problem. */

struct netParsedUrl
/* A parsed URL. */
   {
   char protocol[16];	/* Protocol - http or ftp, etc. */
   char user[128];	/* User name (optional)  */
   char password[128];	/* Password  (optional)  */
   char host[128];	/* Name of host computer - www.yahoo.com, etc. */
   char port[16];       /* Port, usually 80 or 8080. */
   char file[2024];	/* Remote file name/query string, starts with '/' */
   ssize_t byteRangeStart; /* Start of byte range, use -1 for none */
   ssize_t byteRangeEnd;   /* End of byte range use -1 for none */
   };

void netParseUrl(char *url, struct netParsedUrl *parsed);
/* Parse a URL into components.   A full URL is made up as so:
 *   http://user:password@hostName:port/file;byterange=0-499
 * User and password may be cgi-encoded.
 * This is set up so that the http:// and the port are optional. 
 */

char *urlFromNetParsedUrl(struct netParsedUrl *npu);
/* Build URL from netParsedUrl structure */

int netUrlOpen(char *url);
/* Return socket descriptor (low-level file handle) for read()ing url data,
 * or -1 if error.  Just close(result) when done. Errors from this routine
 * from web urls are rare, because this just opens up enough to read header,
 * which may just say "file not found." Consider using netUrlMustOpenPastHeader
 * instead .*/

int netUrlOpenSockets(char *url, int *retCtrlSocket);
/* Return socket descriptor (low-level file handle) for read()ing url data,
 * or -1 if error. 
 * If retCtrlSocket is non-NULL and url is FTP, set *retCtrlSocket
 * to the FTP control socket which is left open for a persistent connection.
 * close(result) (and close(*retCtrlSocket) if applicable) when done. */

struct hash;

int netUrlHeadExt(char *url, char *method, struct hash *hash);
/* Go get head and return status.  Return negative number if
 * can't get head. If hash is non-null, fill it with header
 * lines with upper cased keywords for case-insensitive lookup,
 * including hopefully CONTENT-TYPE: . */

int netUrlHead(char *url, struct hash *hash);
/* Go get head and return status.  Return negative number if
 * can't get head. If hash is non-null, fill it with header
 * lines with upper cased keywords for case-insensitive lookup, 
 * including hopefully CONTENT-TYPE: . */

 int netUrlFakeHeadByGet(char *url, struct hash *hash);
/* Use GET with byteRange as an alternate method to HEAD.
 * Return status. */


struct lineFile *netLineFileMayOpen(char *url);
/* Same as netLineFileOpen, but warns and returns
 * null rather than aborting on problems. */

struct lineFile *netLineFileSilentOpen(char *url);
/* Open a lineFile on a URL.  Just return NULL without any user
 * visible warning message if there's a problem. */

struct dyString *netSlurpFile(int sd);
/* Slurp file into dynamic string and return.  Result will include http headers and
 * the like. */

struct lineFile *netHttpLineFileMayOpen(char *url, struct netParsedUrl **npu);
/* Parse URL and open an HTTP socket for it but don't send a request yet. */

void netHttpGet(struct lineFile *lf, struct netParsedUrl *npu,
		boolean keepAlive);
/* Send a GET request, possibly with Keep-Alive. */

int netOpenHttpExt(char *url, char *method, char *optionalHeader);
/* Return a file handle that will read the url.  optionalHeader
 * may by NULL or may contain cookies and other info. */

int netHttpConnect(char *url, char *method, char *protocol, char *agent, char *optionalHeader);
/* Parse URL, connect to associated server on port, and send most of
 * the request to the server.  If specified in the url send user name
 * and password too.  Typically the "method" will be "GET" or "POST"
 * and the agent will be the name of your program or
 * library. optionalHeader may be NULL or contain additional header
 * lines such as cookie info. 
 * Proxy support via hg.conf httpProxy or env var http_proxy
 * Return data socket, or -1 if error.*/

char *transferParamsToRedirectedUrl(char *url, char *newUrl);
/* Transfer password, byteRange, and any other parameters from url to newUrl and return result.
 * freeMem result. */

boolean netSkipHttpHeaderLinesWithRedirect(int sd, char *url, char **redirectedUrl);
/* Skip http header lines. Return FALSE if there's a problem.
 * The input is a standard sd or fd descriptor.
 * This is meant to be able work even with a re-passable stream handle,
 * e.g. can pass it to the pipes routines, which means we can't
 * attach a linefile since filling its buffer reads in more than just the http header.
 * Handles 300, 301, 302, 303, 307 http redirects by setting *redirectedUrl to
 * the new location. */

boolean netSkipHttpHeaderLinesHandlingRedirect(int sd, char *url, int *redirectedSd, char **redirectedUrl);
/* Skip http headers lines, returning FALSE if there is a problem.  Generally called as
 *    netSkipHttpHeaderLine(sd, url, &sd, &url);
 * where sd is a socket (file) opened with netUrlOpen(url), and url is in dynamic memory.
 * If the http header indicates that the file has moved, then it will update the *redirectedSd and
 * *redirectedUrl with the new socket and URL, first closing sd.
 * If for some reason you want to detect whether the forwarding has occurred you could
 * call this as:
 *    char *newUrl = NULL;
 *    int newSd = 0;
 *    netSkipHttpHeaderLine(sd, url, &newSd, &newUrl);
 *    if (newUrl != NULL)
 *          // Update sd with newSd, free url if appropriate and replace it with newUrl, etc.
 *          //  free newUrl when finished.
 * This routine handles up to 5 steps of redirection.
 * The logic to this routine is also complicated a little to make it work in a pipe, which means we
 * can't attach a lineFile since filling the lineFile buffer reads in more than just the http header. */

boolean netGetFtpInfo(char *url, long long *retSize, time_t *retTime);
/* Return date in UTC and size of ftp url file */

boolean hasProtocol(char *urlOrPath);
/* Return TRUE if it looks like it has http://, ftp:// etc. */
#endif /* NET_H */

