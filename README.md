The purpose of this program is to gather analytics on what kinds of links are shared (and actually
clicked on) from within Facebook.

The script scans FB Graph for cached link objects, which are populated when a FB user clicks on
a link from:

 * any post or comment (including private posts and and private groups[1])
 * any private message over Messenger[1]

Includes two methods for scanning URLs: sequentially or with random mutation. TL;DR use the former
when it's just you scanning, use the latter when you're distributing load or want to "get lucky".

Also includes a generic Reporter class and an IrcReporter skeleton. Reporters print found results
to some medium; the included one connects to an IRC network and posts finds to channel #scanner.

Future work:

 * Excluding "boring" domains (e.g. apps.facebook.com), highlighting interesting ones, and
   segmenting the rest by category/market.

See also:
 [1] http://qz.com/715019/why-you-shouldnt-share-links-on-facebook/