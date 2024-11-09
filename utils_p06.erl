-module(utils_p06).
-author("vkykalo").
-import(utils_p05, [reverse/1]).
-export([is_palindrome/1]).

is_palindrome([]) -> true;
is_palindrome([_]) -> true; 
is_palindrome(List) ->
    ReverseList = reverse(List),
    is_palindrome(List, ReverseList).

is_palindrome(List, List) -> true;
is_palindrome(_, _) -> false.

