using JuMP, Clp

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, 0 <= f <= 1000)
@variable(m, 0 <= s <= 1500)
@constraint(m, 4f + 2s <= 4800)
@constraint(m, f + s <= 1750)
@objective(m, Max, 12f + 9s)

status = optimize!(m)

println("We need to build ", value(f), " football trophies.")
println("We need to build ", value(s), " soccer trophies.")
println("The maximum profit possible is: \$", objective_value(m))
