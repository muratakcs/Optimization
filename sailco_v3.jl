using JuMP, Clp, Printf

d = [40 60 75 25]                   # monthly demand for boats

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, 0 <= x[1:4] <= 40)       # boats produced with regular labor
@variable(m, y[1:4] >= 0)             # boats produced with overtime labor
@variable(m, h[1:5] >= 0)             # boats held in inventory
@variable(m, hm[1:5] >= 0)             # boats held in inventory
@variable(m, cp[1:4] >= 0)
@variable(m, cm[1:4] >= 0)


@constraint(m, h[1] == 10)
@constraint(m, hm[1] == 0)
@constraint(m, h[5] >= 10)
@constraint(m, hm[5] == 0)
@constraint(m, flow[i in 1:4], h[i]-hm[i]+x[i]+y[i]==d[i]+h[i+1]-hm[i+1])     # conservation of boats
@constraint(m, x[1]+y[1]-50==cp[1]-cm[1])
@constraint(m, flow2[i in 2:4], x[i]+y[i]-x[i-1]-y[i-1] == cp[i]-cm[i])
@objective(m, Min, 400*sum(x) + 450*sum(y) + 20*sum(h) + 400*sum(cp) + 500*sum(cm) + 100*sum(hm))         # minimize costs

optimize!(m)

@printf("Boats to build regular labor: %d %d %d %d\n", value(x[1]), value(x[2]), value(x[3]), value(x[4]))
@printf("Boats to build extra labor: %d %d %d %d\n", value(y[1]), value(y[2]), value(y[3]), value(y[4]))
@printf("Increase in production: %d %d %d %d\n", value(cp[1]), value(cp[2]), value(cp[3]), value(cp[4]))
@printf("Decrease in production: %d %d %d %d\n", value(cm[1]), value(cm[2]), value(cm[3]), value(cm[4]))
@printf("Inventories: %d %d %d %d %d\n ", value(h[1]), value(h[2]), value(h[3]), value(h[4]), value(h[5]))

@printf("Objective cost: %f\n", objective_value(m))
