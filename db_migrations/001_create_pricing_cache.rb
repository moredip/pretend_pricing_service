Sequel.migration do
  up do
    create_table(:pricing_cache) do
      String :sku, :null=>false
      DateTime :timestamp, :null=>false
      BigDecimal :price, :null=>false
    end
  end

  down do
    drop_table(:pricing_cache)
  end
end
