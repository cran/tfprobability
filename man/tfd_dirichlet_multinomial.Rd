% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/distributions.R
\name{tfd_dirichlet_multinomial}
\alias{tfd_dirichlet_multinomial}
\title{Dirichlet-Multinomial compound distribution}
\usage{
tfd_dirichlet_multinomial(
  total_count,
  concentration,
  validate_args = FALSE,
  allow_nan_stats = TRUE,
  name = "DirichletMultinomial"
)
}
\arguments{
\item{total_count}{Non-negative floating point tensor, whose dtype is the same
as \code{concentration}. The shape is broadcastable to \verb{[N1,..., Nm]} with
\code{m >= 0}. Defines this as a batch of \verb{N1 x ... x Nm} different
Dirichlet multinomial distributions. Its components should be equal to
integer values.}

\item{concentration}{Positive floating point tensor, whose dtype is the
same as \code{n} with shape broadcastable to \verb{[N1,..., Nm, K]} \code{m >= 0}.
Defines this as a batch of \verb{N1 x ... x Nm} different \code{K} class Dirichlet
multinomial distributions.}

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
The Dirichlet-Multinomial distribution is parameterized by a (batch of)
length-\code{K} \code{concentration} vectors (\code{K > 1}) and a \code{total_count} number of
trials, i.e., the number of trials per draw from the DirichletMultinomial. It
is defined over a (batch of) length-\code{K} vector \code{counts} such that
\code{tf$reduce_sum(counts, -1) = total_count}. The Dirichlet-Multinomial is
identically the Beta-Binomial distribution when \code{K = 2}.
}
\details{
Mathematical Details

The Dirichlet-Multinomial is a distribution over \code{K}-class counts, i.e., a
length-\code{K} vector of non-negative integer \verb{counts = n = [n_0, ..., n_\{K-1\}]}.

The probability mass function (pmf) is,

\if{html}{\out{<div class="sourceCode">}}\preformatted{pmf(n; alpha, N) = Beta(alpha + n) / (prod_j n_j!) / Z
Z = Beta(alpha) / N!
}\if{html}{\out{</div>}}

where:
\itemize{
\item \verb{concentration = alpha = [alpha_0, ..., alpha_\{K-1\}]}, \code{alpha_j > 0},
\item \code{total_count = N}, \code{N} a positive integer,
\item \verb{N!} is \code{N} factorial, and,
\item \verb{Beta(x) = prod_j Gamma(x_j) / Gamma(sum_j x_j)} is the
\href{https://en.wikipedia.org/wiki/Beta_function#Multivariate_beta_function}{multivariate beta function},
and,
\item \code{Gamma} is the \href{https://en.wikipedia.org/wiki/Gamma_function}{gamma function}.
}

Dirichlet-Multinomial is a \href{https://en.wikipedia.org/wiki/Compound_probability_distribution}{compound distribution}, i.e., its
samples are generated as follows.
\enumerate{
\item Choose class probabilities:
\verb{probs = [p_0,...,p_\{K-1\}] ~ Dir(concentration)}
\item Draw integers:
\verb{counts = [n_0,...,n_\{K-1\}] ~ Multinomial(total_count, probs)}
}

The last \code{concentration} dimension parametrizes a single Dirichlet-Multinomial
distribution. When calling distribution functions (e.g., \code{dist$prob(counts)}),
\code{concentration}, \code{total_count} and \code{counts} are broadcast to the same shape.
The last dimension of \code{counts} corresponds single Dirichlet-Multinomial distributions.
Distribution parameters are automatically broadcast in all functions; see examples for details.

Pitfalls
The number of classes, \code{K}, must not exceed:
\itemize{
\item the largest integer representable by \code{self$dtype}, i.e.,
\code{2**(mantissa_bits+1)} (IEE754),
\item the maximum \code{Tensor} index, i.e., \code{2**31-1}.
}

Note: This condition is validated only when \code{validate_args = TRUE}.
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
\code{\link{tfd_variational_gaussian_process}()},
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
