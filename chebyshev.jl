A = [2 -1 2; -1 2 4; 1 2 -2; -1 0 0; 0 -1 0; 0 0 -1];
b = [2; 16; 8; 0; 0; 0]

using JuMP, Clp, LinearAlgebra

m = Model(with_optimizer(Clp.Optimizer))
@variable(m, r >= 0)           # radius
@variable(m, x[1:3])           # coordinates of center
for i = 1:size(A,1)
    @constraint(m, A[i,:]'*x + r*norm(A[i,:]) <= b[i])
end
@objective(m, Max, r)     # maximize radius

optimize!(m)
center = [value(x[1]), value(x[2]), value(x[3])]
radius = value(r)

println("The coordinates of the Chebyshev center are: ", center)
println("The largest possible radius is: ", radius)
