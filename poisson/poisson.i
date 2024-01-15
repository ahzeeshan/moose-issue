[Mesh]
  [./mesh]
   dim = 1
   type = GeneratedMeshGenerator
   nx = 100000
   xmax = 100e-9
  [../]
[]

[Variables]
  [./phi]
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = phi
  [../]
  [./rhobyeps_term]
    type = MaskedBodyForce
    variable = phi
    value = 1.0
    function = 't/10'
    mask = rhobyeps
  [../]
[]

[ICs]
  active = 'ic_random'
  [./ic_random]
    type = RandomIC
    variable = phi
    max = 0.2
    min = 0
  [../]
[]
  
[Materials]
  [./consts]
    type = GenericConstantMaterial
    prop_names = 'eps N kT e dfepos0 dfeneg0'
    prop_values = '1e-10 5.98412e28 4.14e-21 1.6e-19 0.3e-19 0.3e-19'
  [../]
  [./dfepos]
    type = DerivativeParsedMaterial
    material_property_names = 'dfepos0 e'
    property_name = 'dfepos'
    coupled_variables =	'phi'
    expression = 'dfepos0 + e * phi'
    derivative_order = 2
    outputs = other
  [../]
  [./dfeneg]
    type = DerivativeParsedMaterial
    property_name = 'dfeneg'
    coupled_variables = 'phi'
    material_property_names = 'dfeneg0 e'
    expression = 'dfeneg0 - e*phi'
    derivative_order = 2
    outputs = other
  [../]
  [./cpos]
    type = DerivativeParsedMaterial
    property_name = cpos
    material_property_names = 'dfepos N kT'
    expression = 'N * exp(-dfepos/kT) '
    derivative_order = 2
    outputs = other
  [../]
  [./cneg]
    type = DerivativeParsedMaterial
    property_name = cneg
    material_property_names = 'dfeneg N kT'
    expression = 'N * exp(-dfeneg/kT) '
    derivative_order = 2
    outputs = other
  [../]
  [./rhobyeps]
    type = DerivativeParsedMaterial
    property_name = 'rhobyeps'
    material_property_names = 'cpos cneg e eps'
    expression = 'e*(cpos - cneg)/eps'
    derivative_order = 2
    outputs = other
  [../]
[]
  
[BCs]
  active = 'right left'
  [./left]
    type = DirichletBC
    variable = phi
    boundary = left
    value = 0.2
  [../]
  [./right]
    type = DirichletBC
    variable = phi
    boundary = 'right'
    value = 0.
  [../]
[]

[Preconditioning]
  [./SMP]
  type = SMP
  full = true
#  petsc_options = '-snes_monitor -ksp_monitor_true_residual -snes_converged_reason -ksp_converged_reason'
#  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
#  petsc_options_value = 'asm      31                  preonly       lu           2'
  [../]
[]


  
[Executioner]
#  automatic_scaling = true
  type = Transient
  scheme = bdf2
  verbose = True
  solve_type = 'Newton'
  l_max_its = 50
  l_tol = 1e-6
  nl_max_its = 50
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-12
#  petsc_options = '-snes_monitor -ksp_monitor_true_residual -snes_converged_reason -ksp_converged_reason'
#  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
#  petsc_options_value = 'asm      31                  preonly      lu          4'
#  line_search = 'none'
  petsc_options_iname = -pc_type
  petsc_options_value = asm
  start_time = 0.0
  end_time = 10.0
  dt = 1.0
[]
			       
[Outputs]
  execute_on = 'timestep_end'
  exodus = false
  [./other]        # creates input_other.e
   type = Exodus
   interval = 1
  [../]
  [./checkpt]
   type = Checkpoint
   num_files = 1
   interval = 500
  [../]			       
[]

[Debug]
  show_material_props = true
  show_var_residual_norms = true
[]