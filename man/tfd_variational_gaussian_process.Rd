% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/distributions.R
\name{tfd_variational_gaussian_process}
\alias{tfd_variational_gaussian_process}
\title{Posterior predictive of a variational Gaussian process}
\usage{
tfd_variational_gaussian_process(
  kernel,
  index_points,
  inducing_index_points,
  variational_inducing_observations_loc,
  variational_inducing_observations_scale,
  mean_fn = NULL,
  observation_noise_variance = 0,
  predictive_noise_variance = 0,
  jitter = 1e-06,
  validate_args = FALSE,
  allow_nan_stats = FALSE,
  name = "VariationalGaussianProcess"
)
}
\arguments{
\item{kernel}{\code{PositiveSemidefiniteKernel}-like instance representing the
GP's covariance function.}

\item{index_points}{\code{float} \code{Tensor} representing finite (batch of) vector(s) of
points in the index set over which the VGP is defined. Shape has the
form \verb{[b1, ..., bB, e1, f1, ..., fF]} where \code{F} is the number of feature
dimensions and must equal \code{kernel$feature_ndims} and \code{e1} is the number
(size) of index points in each batch (we denote it \code{e1} to distinguish
it from the numer of inducing index points, denoted \code{e2} below).
Ultimately the VariationalGaussianProcess distribution corresponds to an
\code{e1}-dimensional multivariate normal. The batch shape must be
broadcastable with \code{kernel$batch_shape}, the batch shape of
\code{inducing_index_points}, and any batch dims yielded by \code{mean_fn}.}

\item{inducing_index_points}{\code{float} \code{Tensor} of locations of inducing points in
the index set. Shape has the form \verb{[b1, ..., bB, e2, f1, ..., fF]}, just
like \code{index_points}. The batch shape components needn't be identical to
those of \code{index_points}, but must be broadcast compatible with them.}

\item{variational_inducing_observations_loc}{\code{float} \code{Tensor}; the mean of the
(full-rank Gaussian) variational posterior over function values at the
inducing points, conditional on observed data. Shape has the form \verb{[b1, ..., bB, e2]},
where \verb{b1, ..., bB} is broadcast compatible with other
parameters' batch shapes, and \code{e2} is the number of inducing points.}

\item{variational_inducing_observations_scale}{\code{float} \code{Tensor}; the scale
matrix of the (full-rank Gaussian) variational posterior over function
values at the inducing points, conditional on observed data. Shape has
the form \verb{[b1, ..., bB, e2, e2]}, where \verb{b1, ..., bB} is broadcast
compatible with other parameters and \code{e2} is the number of inducing points.}

\item{mean_fn}{function that acts on index points to produce a (batch
of) vector(s) of mean values at those index points. Takes a \code{Tensor} of
shape \verb{[b1, ..., bB, f1, ..., fF]} and returns a \code{Tensor} whose shape is
(broadcastable with) \verb{[b1, ..., bB]}. Default value: \code{NULL} implies constant zero function.}

\item{observation_noise_variance}{\code{float} \code{Tensor} representing the variance
of the noise in the Normal likelihood distribution of the model. May be
batched, in which case the batch shape must be broadcastable with the
shapes of all other batched parameters (\code{kernel$batch_shape}, \code{index_points}, etc.).
Default value: \code{0.}}

\item{predictive_noise_variance}{\code{float} \code{Tensor} representing additional
variance in the posterior predictive model. If \code{NULL}, we simply re-use
\code{observation_noise_variance} for the posterior predictive noise. If set
explicitly, however, we use the given value. This allows us, for
example, to omit predictive noise variance (by setting this to zero) to
obtain noiseless posterior predictions of function values, conditioned
on noisy observations.}

\item{jitter}{\code{float} scalar \code{Tensor} added to the diagonal of the covariance
matrix to ensure positive definiteness of the covariance matrix. Default value: \code{1e-6}.}

\item{validate_args}{Logical, default FALSE. When TRUE distribution parameters are checked
for validity despite possibly degrading runtime performance. When FALSE invalid inputs may
silently render incorrect outputs. Default value: FALSE.}

\item{allow_nan_stats}{Logical, default TRUE. When TRUE, statistics (e.g., mean, mode, variance)
use the value NaN to indicate the result is undefined. When FALSE, an exception is raised if
one or more of the statistic's batch members are undefined.}

\item{name}{name prefixed to Ops created by this class.}
}
\value{
a distribution instance.
}
\description{
This distribution implements the variational Gaussian process (VGP), as
described in Titsias (2009) and Hensman (2013). The VGP is an
inducing point-based approximation of an exact GP posterior.
Ultimately, this Distribution class represents a marginal distribution over function values at a
collection of \code{index_points}. It is parameterized by
\itemize{
\item a kernel function,
\item a mean function,
\item the (scalar) observation noise variance of the normal likelihood,
\item a set of index points,
\item a set of inducing index points, and
\item the parameters of the (full-rank, Gaussian) variational posterior
distribution over function values at the inducing points, conditional on some observations.
}
}
\details{
A VGP is "trained" by selecting any kernel parameters, the locations of the
inducing index points, and the variational parameters. Titsias (2009) and
Hensman (2013) describe a variational lower bound on the marginal log
likelihood of observed data, which this class offers through the
\code{variational_loss} method (this is the negative lower bound, for convenience
when plugging into a TF Optimizer's \code{minimize} function).
Training may be done in minibatches.

Titsias (2009) describes a closed form for the optimal variational
parameters, in the case of sufficiently small observational data (ie,
small enough to fit in memory but big enough to warrant approximating the GP
posterior). A method to compute these optimal parameters in terms of the full
observational data set is provided as a staticmethod,
\code{optimal_variational_posterior}. It returns a
\code{MultivariateNormalLinearOperator} instance with optimal location and scale parameters.

Mathematical Details

Notation
We will in general be concerned about three collections of index points, and
it'll be good to give them names:
\itemize{
\item \verb{x[1], ..., x[N]}: observation index points -- locations of our observed data.
\item \verb{z[1], ..., z[M]}: inducing index points  -- locations of the
"summarizing" inducing points
\item \verb{t[1], ..., t[P]}: predictive index points -- locations where we are
making posterior predictions based on observations and the variational
parameters.
}

To lighten notation, we'll use \verb{X, Z, T} to denote the above collections.
Similarly, we'll denote by \code{f(X)} the collection of function values at each of
the \code{x[i]}, and by \code{Y}, the collection of (noisy) observed data at each \code{x[i]}.
We'll denote kernel matrices generated from pairs of index points as \code{K_tt},
\code{K_xt}, \code{K_tz}, etc, e.g.,

\if{html}{\out{<div class="sourceCode">}}\preformatted{K_tz =
| k(t[1], z[1])    k(t[1], z[2])  ...  k(t[1], z[M]) |
| k(t[2], z[1])    k(t[2], z[2])  ...  k(t[2], z[M]) |
|      ...              ...                 ...      |
| k(t[P], z[1])    k(t[P], z[2])  ...  k(t[P], z[M]) |

}\if{html}{\out{</div>}}

Preliminaries
A Gaussian process is an indexed collection of random variables, any finite
collection of which are jointly Gaussian. Typically, the index set is some
finite-dimensional, real vector space, and indeed we make this assumption in
what follows. The GP may then be thought of as a distribution over functions
on the index set. Samples from the GP are functions \emph{on the whole index set};
these can't be represented in finite compute memory, so one typically works
with the marginals at a finite collection of index points. The properties of
the GP are entirely determined by its mean function \code{m} and covariance
function \code{k}. The generative process, assuming a mean-zero normal likelihood
with stddev \code{sigma}, is

\if{html}{\out{<div class="sourceCode">}}\preformatted{f ~ GP(m, k)
Y | f(X) ~ Normal(f(X), sigma),   i = 1, ... , N
}\if{html}{\out{</div>}}

In finite terms (ie, marginalizing out all but a finite number of f(X), sigma),
we can write

\if{html}{\out{<div class="sourceCode">}}\preformatted{f(X) ~ MVN(loc=m(X), cov=K_xx)
Y | f(X) ~ Normal(f(X), sigma),   i = 1, ... , N
}\if{html}{\out{</div>}}

Posterior inference is possible in analytical closed form but becomes
intractible as data sizes get large. See Rasmussen (2006) for details.

The VGP

The VGP is an inducing point-based approximation of an exact GP posterior,
where two approximating assumptions have been made:
\enumerate{
\item function values at non-inducing points are mutually independent
conditioned on function values at the inducing points,
\item the (expensive) posterior over function values at inducing points
conditional on obseravtions is replaced with an arbitrary (learnable)
full-rank Gaussian distribution,
}

\if{html}{\out{<div class="sourceCode">}}\preformatted{q(f(Z)) = MVN(loc=m, scale=S),
}\if{html}{\out{</div>}}

where \code{m} and \code{S} are parameters to be chosen by optimizing an evidence
lower bound (ELBO).
The posterior predictive distribution becomes

\if{html}{\out{<div class="sourceCode">}}\preformatted{q(f(T)) = integral df(Z) p(f(T) | f(Z)) q(f(Z)) = MVN(loc = A @ m, scale = B^(1/2))
}\if{html}{\out{</div>}}

where

\if{html}{\out{<div class="sourceCode">}}\preformatted{A = K_tz @ K_zz^-1
B = K_tt - A @ (K_zz - S S^T) A^T
}\if{html}{\out{</div>}}

The approximate posterior predictive distribution \code{q(f(T))} is what the
\code{VariationalGaussianProcess} class represents.

Model selection in this framework entails choosing the kernel parameters,
inducing point locations, and variational parameters. We do this by optimizing
a variational lower bound on the marginal log likelihood of observed data. The
lower bound takes the following form (see Titsias (2009) and
Hensman (2013) for details on the derivation):

\if{html}{\out{<div class="sourceCode">}}\preformatted{L(Z, m, S, Y) = MVN(loc=
(K_zx @ K_zz^-1) @ m, scale_diag=sigma).log_prob(Y) -
(Tr(K_xx - K_zx @ K_zz^-1 @ K_xz) +
Tr(S @ S^T @ K_zz^1 @ K_zx @ K_xz @ K_zz^-1)) / (2 * sigma^2) -
KL(q(f(Z)) || p(f(Z))))
}\if{html}{\out{</div>}}

where in the final KL term, \code{p(f(Z))} is the GP prior on inducing point
function values. This variational lower bound can be computed on minibatches
of the full data set \verb{(X, Y)}. A method to compute the \emph{negative} variational
lower bound is implemented as \code{VariationalGaussianProcess$variational_loss}.

Optimal variational parameters

As described in Titsias (2009), a closed form optimum for the variational
location and scale parameters, \code{m} and \code{S}, can be computed when the
observational data are not prohibitively voluminous. The
\code{optimal_variational_posterior} function to computes the optimal variational
posterior distribution over inducing point function values in terms of the GP
parameters (mean and kernel functions), inducing point locations, observation
index points, and observations. Note that the inducing index point locations
must still be optimized even when these parameters are known functions of the
inducing index points. The optimal parameters are computed as follows:

\if{html}{\out{<div class="sourceCode">}}\preformatted{C = sigma^-2 (K_zz + K_zx @ K_xz)^-1
optimal Gaussian covariance: K_zz @ C @ K_zz
optimal Gaussian location: sigma^-2 K_zz @ C @ K_zx @ Y
}\if{html}{\out{</div>}}
}
\section{References}{

\itemize{
\item \href{http://proceedings.mlr.press/v5/titsias09a/titsias09a.pdf}{Titsias, M. "Variational Model Selection for Sparse Gaussian Process Regression", 2009.}
\item \href{https://arxiv.org/abs/1309.6835}{Hensman, J., Lawrence, N. "Gaussian Processes for Big Data", 2013.}
\item \href{http://gaussianprocess.org/gpml/}{Carl Rasmussen, Chris Williams. Gaussian Processes For Machine Learning, 2006.}
}
}

\seealso{
For usage examples see e.g. \code{\link[=tfd_sample]{tfd_sample()}}, \code{\link[=tfd_log_prob]{tfd_log_prob()}}, \code{\link[=tfd_mean]{tfd_mean()}}.

Other distributions: 
\code{\link{tfd_autoregressive}()},
\code{\link{tfd_batch_reshape}()},
\code{\link{tfd_bates}()},
\code{\link{tfd_bernoulli}()},
\code{\link{tfd_beta_binomial}()},
\code{\link{tfd_beta}()},
\code{\link{tfd_binomial}()},
\code{\link{tfd_categorical}()},
\code{\link{tfd_cauchy}()},
\code{\link{tfd_chi2}()},
\code{\link{tfd_chi}()},
\code{\link{tfd_cholesky_lkj}()},
\code{\link{tfd_continuous_bernoulli}()},
\code{\link{tfd_deterministic}()},
\code{\link{tfd_dirichlet_multinomial}()},
\code{\link{tfd_dirichlet}()},
\code{\link{tfd_empirical}()},
\code{\link{tfd_exp_gamma}()},
\code{\link{tfd_exp_inverse_gamma}()},
\code{\link{tfd_exponential}()},
\code{\link{tfd_gamma_gamma}()},
\code{\link{tfd_gamma}()},
\code{\link{tfd_gaussian_process_regression_model}()},
\code{\link{tfd_gaussian_process}()},
\code{\link{tfd_generalized_normal}()},
\code{\link{tfd_geometric}()},
\code{\link{tfd_gumbel}()},
\code{\link{tfd_half_cauchy}()},
\code{\link{tfd_half_normal}()},
\code{\link{tfd_hidden_markov_model}()},
\code{\link{tfd_horseshoe}()},
\code{\link{tfd_independent}()},
\code{\link{tfd_inverse_gamma}()},
\code{\link{tfd_inverse_gaussian}()},
\code{\link{tfd_johnson_s_u}()},
\code{\link{tfd_joint_distribution_named_auto_batched}()},
\code{\link{tfd_joint_distribution_named}()},
\code{\link{tfd_joint_distribution_sequential_auto_batched}()},
\code{\link{tfd_joint_distribution_sequential}()},
\code{\link{tfd_kumaraswamy}()},
\code{\link{tfd_laplace}()},
\code{\link{tfd_linear_gaussian_state_space_model}()},
\code{\link{tfd_lkj}()},
\code{\link{tfd_log_logistic}()},
\code{\link{tfd_log_normal}()},
\code{\link{tfd_logistic}()},
\code{\link{tfd_mixture_same_family}()},
\code{\link{tfd_mixture}()},
\code{\link{tfd_multinomial}()},
\code{\link{tfd_multivariate_normal_diag_plus_low_rank}()},
\code{\link{tfd_multivariate_normal_diag}()},
\code{\link{tfd_multivariate_normal_full_covariance}()},
\code{\link{tfd_multivariate_normal_linear_operator}()},
\code{\link{tfd_multivariate_normal_tri_l}()},
\code{\link{tfd_multivariate_student_t_linear_operator}()},
\code{\link{tfd_negative_binomial}()},
\code{\link{tfd_normal}()},
\code{\link{tfd_one_hot_categorical}()},
\code{\link{tfd_pareto}()},
\code{\link{tfd_pixel_cnn}()},
\code{\link{tfd_poisson_log_normal_quadrature_compound}()},
\code{\link{tfd_poisson}()},
\code{\link{tfd_power_spherical}()},
\code{\link{tfd_probit_bernoulli}()},
\code{\link{tfd_quantized}()},
\code{\link{tfd_relaxed_bernoulli}()},
\code{\link{tfd_relaxed_one_hot_categorical}()},
\code{\link{tfd_sample_distribution}()},
\code{\link{tfd_sinh_arcsinh}()},
\code{\link{tfd_skellam}()},
\code{\link{tfd_spherical_uniform}()},
\code{\link{tfd_student_t_process}()},
\code{\link{tfd_student_t}()},
\code{\link{tfd_transformed_distribution}()},
\code{\link{tfd_triangular}()},
\code{\link{tfd_truncated_cauchy}()},
\code{\link{tfd_truncated_normal}()},
\code{\link{tfd_uniform}()},
\code{\link{tfd_vector_diffeomixture}()},
\code{\link{tfd_vector_exponential_diag}()},
\code{\link{tfd_vector_exponential_linear_operator}()},
\code{\link{tfd_vector_laplace_diag}()},
\code{\link{tfd_vector_laplace_linear_operator}()},
\code{\link{tfd_vector_sinh_arcsinh_diag}()},
\code{\link{tfd_von_mises_fisher}()},
\code{\link{tfd_von_mises}()},
\code{\link{tfd_weibull}()},
\code{\link{tfd_wishart_linear_operator}()},
\code{\link{tfd_wishart_tri_l}()},
\code{\link{tfd_wishart}()},
\code{\link{tfd_zipf}()}
}
\concept{distributions}
