%% @author Seth Falcon <seth@userprimary.net>
%% @copyright 2009 Seth Falcon.
-module(base62).

-compile([native]).

-export([char_to_digit/1, decode/1, digit_to_char/1,
	 encode/1, is_valid/1]).

%% @spec encode(integer()) -> string()
%% @doc encode an integer into base 62 using 0-9, A-Z, and a-z
encode(I) ->
    unicode:characters_to_binary(encode(I, [])).

%% @spec decode(string()) -> integer()
%% @doc decode a string encoded in base 62 to an integer
decode(S) ->
    decode(lists:reverse(unicode:characters_to_list(S)), 1,
	   0).

digit_to_char(D) when D < 10 -> $0 + D;
digit_to_char(D) when D < 36 -> $0 + 7 + D;
digit_to_char(D) when D < 62 -> $0 + 13 + D.

char_to_digit(C) when C < 10 + $0 -> C - $0;
char_to_digit(C) when C < 43 + $0 -> C - 7 - $0;
char_to_digit(C) when C < 75 + $0 -> C - 13 - $0.

encode(I, Acc) when I < 62 -> [digit_to_char(I) | Acc];
encode(I, Acc) ->
    I1 = I div 62,
    encode(I1, [digit_to_char(I rem 62) | Acc]).

%% Skip non-valid characters, like spaces
decode([C | T], N, Acc) when (C < $0) or (C >= $0 + 74)  ->
    decode(T, N, Acc);
decode([C | T], N, Acc) ->
    decode(T, N * 62, char_to_digit(C) * N + Acc);
decode([], _N, Acc) -> Acc.

is_valid(S) ->
    is_valid(unicode:characters_to_list(S), true).

is_valid([], Verdict) -> Verdict;
is_valid([C | T], true)
    when (C >= $0) and (C < 75 + $0) ->
    is_valid(T, true);
is_valid(_S, _V) -> false.
