inherited VMCustomers: TVMCustomers
  Width = 541
  inherited MPMaster: TioModelPresenterMaster
    TypeName = 'IGenericCustomer'
    VirtualFields = True
    Paging.CurrentPageOfFormat = 'Page %d of %d'
    Paging.PageSize = 50
    Paging.PagingType = ptHardPaging
  end
  object acNextPage: TioVMActionBSNextPage
    Name = 'acNextPage'
    TargetBindSource = MPMaster
    Left = 312
    Top = 48
  end
  object acPrevPage: TioVMActionBSPrevPage
    Name = 'acPrevPage'
    TargetBindSource = MPMaster
    Left = 312
    Top = 112
  end
end
