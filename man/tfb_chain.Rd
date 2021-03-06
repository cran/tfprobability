% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bijectors.R
\name{tfb_chain}
\alias{tfb_chain}
\title{Bijector which applies a sequence of bijectors}
\usage{
tfb_chain(
  bijectors = NULL,
  validate_args = FALSE,
  validate_event_size = TRUE,
  parameters = NULL,
  name = NULL
)
}
\arguments{
\item{bijectors}{list of bijector instances. An empty list makes this
bijector equivalent to the Identity bijector.}

\item{validate_args}{Logical indicating whether arguments should be checked for correctness.}

\item{validate_event_size}{Checks that bijectors are not applied to inputs with
incomplete support (that is, inputs where one or more elements are a
deterministic transformation of the others). For example, the following
LDJ would be incorrect:
\code{tfb_chain(list(tfb_scale(), tfb_softmax_centered()))$forward_log_det_jacobian(matrix(1:2, ncol = 2))}
The jacobian contribution from \code{tfb_scale()} applies to a 2-dimensional input,
but the output from \code{tfb_softmax_centered()} is a 1-dimensional input embedded
in a 2-dimensional space. Setting \code{validate_event_size=TRUE} (default)
prints warnings in these cases. When \code{validate_args} is also \code{TRUE}, the
warning is promoted to an exception.}

\item{parameters}{Locals dict captured by subclass constructor, to be used for
copy/slice re-instantiation operators.}

\item{name}{String, name given to ops managed by this object. Default:
E.g., \code{tfb_chain(list(tfb_exp(), tfb_softplus()))$name == "chain_of_exp_of_softplus"}.}
}
\value{
a bijector instance.
}
\description{
Bijector which applies a sequence of bijectors
}
\seealso{
For usage examples see \code{\link[=tfb_forward]{tfb_forward()}}, \code{\link[=tfb_inverse]{tfb_inverse()}}, \code{\link[=tfb_inverse_log_det_jacobian]{tfb_inverse_log_det_jacobian()}}.

Other bijectors: 
\code{\link{tfb_absolute_value}()},
\code{\link{tfb_affine_linear_operator}()},
\code{\link{tfb_affine_scalar}()},
\code{\link{tfb_affine}()},
\code{\link{tfb_ascending}()},
\code{\link{tfb_batch_normalization}()},
\code{\link{tfb_blockwise}()},
\code{\link{tfb_cholesky_outer_product}()},
\code{\link{tfb_cholesky_to_inv_cholesky}()},
\code{\link{tfb_correlation_cholesky}()},
\code{\link{tfb_cumsum}()},
\code{\link{tfb_discrete_cosine_transform}()},
\code{\link{tfb_expm1}()},
\code{\link{tfb_exp}()},
\code{\link{tfb_ffjord}()},
\code{\link{tfb_fill_scale_tri_l}()},
\code{\link{tfb_fill_triangular}()},
\code{\link{tfb_glow}()},
\code{\link{tfb_gompertz_cdf}()},
\code{\link{tfb_gumbel_cdf}()},
\code{\link{tfb_gumbel}()},
\code{\link{tfb_identity}()},
\code{\link{tfb_inline}()},
\code{\link{tfb_invert}()},
\code{\link{tfb_iterated_sigmoid_centered}()},
\code{\link{tfb_kumaraswamy_cdf}()},
\code{\link{tfb_kumaraswamy}()},
\code{\link{tfb_lambert_w_tail}()},
\code{\link{tfb_masked_autoregressive_default_template}()},
\code{\link{tfb_masked_autoregressive_flow}()},
\code{\link{tfb_masked_dense}()},
\code{\link{tfb_matrix_inverse_tri_l}()},
\code{\link{tfb_matvec_lu}()},
\code{\link{tfb_normal_cdf}()},
\code{\link{tfb_ordered}()},
\code{\link{tfb_pad}()},
\code{\link{tfb_permute}()},
\code{\link{tfb_power_transform}()},
\code{\link{tfb_rational_quadratic_spline}()},
\code{\link{tfb_rayleigh_cdf}()},
\code{\link{tfb_real_nvp_default_template}()},
\code{\link{tfb_real_nvp}()},
\code{\link{tfb_reciprocal}()},
\code{\link{tfb_reshape}()},
\code{\link{tfb_scale_matvec_diag}()},
\code{\link{tfb_scale_matvec_linear_operator}()},
\code{\link{tfb_scale_matvec_lu}()},
\code{\link{tfb_scale_matvec_tri_l}()},
\code{\link{tfb_scale_tri_l}()},
\code{\link{tfb_scale}()},
\code{\link{tfb_shifted_gompertz_cdf}()},
\code{\link{tfb_shift}()},
\code{\link{tfb_sigmoid}()},
\code{\link{tfb_sinh_arcsinh}()},
\code{\link{tfb_sinh}()},
\code{\link{tfb_softmax_centered}()},
\code{\link{tfb_softplus}()},
\code{\link{tfb_softsign}()},
\code{\link{tfb_split}()},
\code{\link{tfb_square}()},
\code{\link{tfb_tanh}()},
\code{\link{tfb_transform_diagonal}()},
\code{\link{tfb_transpose}()},
\code{\link{tfb_weibull_cdf}()},
\code{\link{tfb_weibull}()}
}
\concept{bijectors}
