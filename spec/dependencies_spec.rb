require File.join( File.dirname(__FILE__), '../lib/dependencies' )

describe Dependencies do

  describe "#direct_dependencies_for" do

    before(:each) do
      @dep = Dependencies.new
      @dep.add_direct('A', %w{B C})
    end

    it "returns directly depending files" do
      @dep.direct_dependencies_for('A').should eq %w{B C}
    end

    it "returns an empty array if the file is independent of the others" do
      @dep.direct_dependencies_for('C').should eq []
    end

    it "returns nil if the file is not found" do
      @dep.direct_dependencies_for('D').should be_nil
    end
  end

  describe "#add_direct" do

    before(:each) do
      @dep = Dependencies.new
    end

    it "adds direct dependencies" do
      @dep.add_direct('A', ['B'])
      expect {
        @dep.add_direct('A', %w{C D})
      }.to change { @dep.direct_dependencies_for('A').count }.by(2)
    end
  end

  describe "#dependencies_for" do

    before(:each) do
      @dep = Dependencies.new
      @dep.add_direct('A', %w{ B C } )
      @dep.add_direct('B', %w{ C E } )
      @dep.add_direct('C', %w{ G   } )
      @dep.add_direct('D', %w{ A F } )
      @dep.add_direct('E', %w{ F   } )
      @dep.add_direct('F', %w{ H   } )
    end

    it "returns dependencies" do
      @dep.dependencies_for('A').should eq %w{ B C E F G H }
      @dep.dependencies_for('B').should eq %w{ C E F G H }
      @dep.dependencies_for('C').should eq %w{ G }
      @dep.dependencies_for('D').should eq %w{ A B C E F G H }
      @dep.dependencies_for('E').should eq %w{ F H }
      @dep.dependencies_for('F').should eq %w{ H }
    end

    it "returns an empty array if the file is independent of the others" do
      @dep.dependencies_for('H').should eq []
    end
  end
  
end