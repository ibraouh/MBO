# Understanding the iterative thresholding method for image segmentation
*Abe Raouh - July 18, 2023*


## Algorithm Steps
#### Step 0
- You start with an initial partition of the image into regions, denoted as Ω1, Ω2, ..., Ωn, and their corresponding characteristic functions u01, u02, ..., un0.

#### Step 1
- At the kth iteration, given the current characteristic functions (uk1, ..., unk), you compute gik and perform convolutions for each region i = 1, 2, ..., n.
- The convolution results in φik, and it involves gik and a term related to the current characteristic function uik of the region Ωi. This term helps approximate the energy functional of the Chan-Vese model.
- The parameters λ, δt, and G are constants used in the computations.

#### Step 2 (Thresholding)
- After computing φik for each region, you determine a new partition Ωk+1 by comparing φik with φjk for all j ≠ i. Ωk+1 consists of the points where φik is smaller than φjk for all other regions j.
- Essentially, Ωk+1 represents the regions where the current characteristic function uik has a smaller value compared to all other regions' characteristic functions.

#### Step 3
- Calculate the normalized L2 difference between the current and previous iterations, denoted as ek+1.
- The normalized L2 difference measures the difference between the characteristic functions of regions in successive iterations, and it is normalized by the size of the image Ω.
- If ek+1 is less than or equal to the tolerance parameter τ, the algorithm stops as it has reached an acceptable segmentation. Otherwise, it goes back to Step 1, continuing the iterative process to refine the image segmentation further.

The algorithm iteratively refines the image segmentation using thresholding and L2 differences between successive iterations. It stops when the segmentation reaches a satisfactory level of accuracy, determined by the tolerance parameter τ.

---
## PseudoCode

Algorithm: Image Segmentation using Chan-Vese Model

**Step 0**

```
Input: Initial partition Ω_1^0, Ω_2^0, ..., Ω_n^0 and corresponding characteristic functions u_01, u_02, ..., u_0n
       Tolerance parameter τ > 0
Output: Final partition Ω_1, Ω_2, ..., Ω_n and their corresponding characteristic functions u_1, u_2, ..., u_n
```

**Step 1**

```
Input: Current iteration's characteristic functions u_k1, u_k2, ..., u_kn for regions Ω_1, Ω_2, ..., Ω_n
Output: Updated characteristic functions u_k+1_1, u_k+1_2, ..., u_k+1_n for regions Ω_1, Ω_2, ..., Ω_n
--

Parameters:
  |- λ: Constant parameter
  |- δt: Constant parameter
  |- G: Constant parameter

For each region i = 1 to n:
	Compute g_ik using the current characteristic functions u_k1, u_k2, ..., u_kn and some region-specific information.
	Perform convolution to compute φ_ik:
		conv_result = Convolution(g_ik, ((2λ√π)/√δt) * (1 − Gδt ∗ u_ik))
		φ_ik = g_ik + conv_result
End For
```

**Step 2**

```
Input: Updated characteristic functions u_k+1_1, u_k+1_2, ..., u_k+1_n for regions Ω_1, Ω_2, ..., Ω_n
Output: New partition Ω_1_k+1, Ω_2_k+1, ..., Ω_n_k+1
--

For each region i = 1 to n:
	Find the minimum value of φ_ik among all regions (j ≠ i):
		min_val = min(φ_i1, φ_i2, ..., φ_in) where j ≠ i
	Construct the new region Ω_i_k+1 by thresholding:
		Ω_i_k+1 = {x : φ_ik(x) < min_val}
End For
```

**Step 3**

```
Input: New partition Ω_1_k+1, Ω_2_k+1, ..., Ω_n_k+1
Output: Updated characteristic functions u_k+1_1, u_k+1_2, ..., u_k+1_n for regions Ω_1_k+1, Ω_2_k+1, ..., Ω_n_k+1
--

For each region i = 1 to n:
	Compute the new characteristic function u_k+1_i for region Ω_i_k+1:
		u_k+1_i = χ(Ω_i_k+1) where χ(Ω_i_k+1) represents the characteristic function of region Ω_i_k+1.
End For
```

**Step 4**

```
Input: Current partition Ω_1_k+1, Ω_2_k+1, ..., Ω_n_k+1 and previous partition Ω_1_k, Ω_2_k, ..., Ω_n_k
Output: Check for convergence
--

Compute the normalized L2 difference between successive iterations:
	e_k+1 = (1/|Ω|) * integral_Ω ( sum_i=1 -> n ( |u_k+1_i − u_k_i|^2 ) dΩ )

If e_k+1 ≤ τ, stop. The algorithm has converged.
Otherwise, go back to Step 1 and repeat the process with the new partition.
```


---
## Professor Notes
1. in step 1, G is not a constant, G_{\delta t}  is the gaussian function. please check the paper and the code I sent you to see what G_{\delta t} is.
2. In step 1, you only need to do fft and inverse fft for the term G_{\delta t}*u. You don't need to do the fft of the whole Equation 26.
