# the types of trophies produced
sports = [:football, :soccer]

# wood required for each type of trophy (in board feet)
wood   = Dict( :football => 4, :soccer => 2)

# plaques required for each type of trophy
plaques = Dict( :football => 1, :soccer => 1)

# profit made for each trophy
profit = Dict( :football => 12, :soccer => 9)

# quantities in stock for each ingredient
num_wood     = 4800
num_plaques  = 1750
num_football = 1000
num_soccer   = 1500
;

using JuMP, Clp

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, trophies[sports] >= 0 )    # "trophies" is a dictionary indexed over sports

@expression(m, tot_plaques, sum(trophies[i] * plaques[i] for i in sports) )
@expression(m, tot_wood,    sum(trophies[i] * wood[i]    for i in sports) )
@expression(m, tot_profit,  sum(trophies[i] * profit[i]  for i in sports) )

@constraint(m, trophies[:soccer] <= num_soccer )      # maximum number of soccer balls
@constraint(m, trophies[:football] <= num_football )  # maximum number of footballs
@constraint(m, tot_plaques <= num_plaques )           # maximum number of plaques
@constraint(m, tot_wood    <= num_wood )              # maximum amount of wood

@objective(m, Max, tot_profit)


status = optimize!(m)

println("Produce \$ soccer   trophies and", value(trophies[:soccer]))
println("Produce \$ football trophies.", value(trophies[:football]))
println("Then the total profit will be \$", value(tot_profit))

println("Total wood used is ", value(tot_wood), " board feet")
println("Total number of plaques used is ", value(tot_plaques))
