Notes from this video


Sampling access to the distribution function, give state and action action I want to take, gives next action and state I will be in

UCT upper confidence bound applied to trees

used in alpha go , explores game tree of go

two things:
incrementally builds the search tree, runs from root of tree, grows tree one node at a time, gradually estimate values of actions, state values and q values (how good is it), mc samples values of these values

draw samples, take an average, problem is u can be very biased/wrong depending on samples drawn

in infinite time mc reaches the right answer

stages:
1. selection -> expand (add next node to tree) -> simulate (use sampler access and take random samples from future in the tree to see whats best) -> backup (takes results from simulation and sends it back up the tree) -> loop

in home state we can take X actions

selecting actions in tree:
choice of actions, choose action that minimizes q value, if we've only taken a few samples so far the q val could be wrong, reflects that we haven't explored the tree
explore vs exploit
focusing efforts on bits of tree that work
exploration term     argmin Q(s,a) **** exploit    -C sqrt(ln(n_s)/n_s,a) **** explore

bandit problem, selects bandits that have mean + upper bound of confidence interval, this gets you high value or high variance

at the beginning forced try all actions once since confidence denominator is 0 and makes the val infiintiy

                ------------------
                -       H        -
                ------------------
                |        |       |
               |         |        -----------|
    --------------   --------------     --------------
    - Q(H, bike) -   -  Q(H,car)  -     - Q(H,train) -
    - ------------   --------------     --------------

bike you rollout down the entire tree and calcultate cost to goal as X number. set value of tree to 45

calculate next node of car and recalculate, determine what its cost is and replace the value of tree if it is lower

keep track of n=X trials (number of samples that we have taken)

keep track of samples in each node, take average on the nodes for the actions in tree below

expansion step discovers  a new state/action

mc is a random algorithm, people usually handles this by running multiple in parallel and then each algorithm votes what they think is best, its online planning, receding horizon control

-C is the specific value which minimizes regret, difference between choice you are making now and the optimal choice, if you use this constant you spend a lot of time exploring, typically u replace it with the value of the state you are looking at.
