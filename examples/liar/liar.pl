% liar.pl -- Knights and Knaves / Liar puzzle
%
% On which days does the lion tell the truth?
% The lion lies on Tuesday and Thursday.
%
% This requires negation-as-failure (\+) which is not yet
% implemented in the LAM VM. See docs/planned-demos.md for
% the feature roadmap.

day(mon).
day(tue).
day(wed).
day(thu).
day(fri).
day(sat).
day(sun).

lies_on(lion, tue).
lies_on(lion, thu).

truthful(Entity, Day) :-
    \+ lies_on(Entity, Day).

statement_true(lion, Day, Goal) :-
    truthful(lion, Day),
    Goal.

statement_true(lion, Day, Goal) :-
    lies_on(lion, Day),
    \+ Goal.

% Queries:
% ?- truthful(lion, Day).
%   -> Day = mon ; Day = wed ; Day = fri ; Day = sat ; Day = sun
%
% ?- statement_true(lion, tue, day(wed)).
%   -> false (lion lies on tue, and day(wed) is true, so
%      the lion would NOT state it as true on a lying day)
%
% ?- statement_true(lion, mon, day(wed)).
%   -> true (lion is truthful on mon, and day(wed) is true)
