rwstep(;p::Real = 0.5,
    rng::AbstractRNG = Random.default_rng()
) = rand(rng) < p ? 1 : -1
