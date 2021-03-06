describe "jets generate" do
  describe "migration" do
    it "creates a migration file" do
      command = "exe/jets dynamodb:generate create_posts --partition-key id:string"
      out = execute(command)
      puts "HIII".color(:yellow)
      # pp out # uncomment to debug
      expect(out).to include("Generating migration")
      migration_path = Dir.glob("#{Dynomite.app_root}dynamodb/migrate/*").first
      migration_exist = File.exist?(migration_path)
      expect(migration_exist).to be true
      FileUtils.rm_f(migration_path)
    end
  end
end
