using Random, Distributions

rwstep(;p::Real = 0.5,
    rng::AbstractRNG = Random.default_rng()
) = rand(rng) < p ? 1 : -1

nstage(
    initial::Int,
    n::Int;
    p::Real = 0.5,
    rng::AbstractRNG = Random.default_rng()
) = initial + 2 * rand(rng, Binomial(n, p)) - n

function randomwalk(
    initial::Int,
    n::Int;
    p::Real = 0.5,
    rng::AbstractRNG = Random.default_rng()
)
    stage = Vector{Int}(undef, n + 1)
    stage[1] = initial
    for i in 1:n
        stage[i+1] = stage[i] + rwstep(;p, rng)
    end
    (steps = 0:n, stage = stage)
end

function gamblerwalk(
    initial::Int,
    win::Int;
    p::Real = 0.5,
    rng::AbstractRNG = Random.default_rng()
)
    S = initial
    steps = 0
    while 0 < S < win
        S += rwstep(;p, rng)
        steps += 1
    end
    (exit = S, time = steps)
end

function gamblerruin(
    initial::Integer,
    win::Integer;
    p::Real = 0.5
)
    win <= 0 && throw(DomainError(win, "Expected win > 0"))
    0 < p < 1 || throw(DomainError(p, "Expected p ∈ (0, 1)"))
    initial <= 0 && return 1.0
    initial >= win && return 0.0
    ρ = log1p(-p) - log(p)
    iszero(ρ) && return 1 - initial / win
    plose = if ρ < 0
        1 - (expm1(initial * ρ) / expm1(win * ρ))
    else
        expm1(ρ * (initial - win)) / expm1(-win * ρ)
    end
    plose
end
