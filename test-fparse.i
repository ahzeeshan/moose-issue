e = 4.14E-05
d = ${fparse 1/e}

[Mesh]
  [./mesh]
   dim = 1
   type = GeneratedMeshGenerator
   nx = 1e2
   xmax = 1
  [../]
[]


[Variables]
  [./phi]
  order = FIRST
  family = LAGRANGE
  [../]
[]


[Kernels]
  [./diff]
    type = Diffusion
    variable = phi
  [../]
[]

[Materials]
    [./consts]
        type = ADGenericConstantMaterial
        prop_names = 'eps e'
        prop_values = '${d} ${e}'
        outputs = exodus
    [../]
[]

[BCs]
    [./left]
    type = DirichletBC
    variable = phi
    boundary = left
    value = 0
    [../]
[]


[Executioner]
  # automatic_scaling = true
  type = Steady 
  verbose = True
  solve_type = 'Newton'
  l_max_its = 50
  l_tol = 1e-6
  nl_max_its = 75
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-16
  petsc_options = '-snes_monitor -ksp_monitor_true_residual -snes_converged_reason -ksp_converged_reason'
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap -sub_pc_factor_shift_type -snes_type'
  petsc_options_value =   'asm      31                  preonly         lu             4       NONZERO vinewtonssls'
[]


[Outputs]
  execute_on = 'initial TIMESTEP_END' #'final' 'initial failed' 
  exodus = true
[]

[Debug]
  # show_material_props = true
  show_var_residual_norms = true
[]

