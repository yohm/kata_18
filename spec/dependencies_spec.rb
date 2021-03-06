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

    context "for non-circular dependencies" do

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

    context "for circular dependencies" do

      before(:each) do
        @dep = Dependencies.new
      end

      it "returns dependencies" do
        @dep.add_direct('A', %w{ B } )
        @dep.add_direct('B', %w{ C } )
        @dep.add_direct('C', %w{ A } )
        @dep.dependencies_for('A').should eq %w{ B C }
        @dep.dependencies_for('B').should eq %w{ A C }
        @dep.dependencies_for('C').should eq %w{ A B }
      end

      it "returns dependencies" do
        @dep.add_direct('A', %w{ B } )
        @dep.add_direct('B', %w{ C } )
        @dep.add_direct('C', %w{ A D } )
        @dep.dependencies_for('A').should eq %w{ B C D }
      end
    end
  end

  describe "#to_heb_json" do

    before(:each) do
      @dep = Dependencies.new
      @dep.add_direct('A', %w{ B } )
      @dep.add_direct('B', %w{ C } )
      @dep.add_direct('C', %w{ A } )
    end

    it "returns a json for rendering hierarchical edge bundling" do
      a = JSON.parse( @dep.to_heb_json )
      a.should be_a(Array)
      a.should have(3).items
      recA = a.find {|rec| rec["name"] == 'A'}
      recA.should be_a(Hash)
      recA['imports'].should eq ["B", "C"]
    end
  end

  describe "#parse" do

    before(:each) do
      @dep = Dependencies.new
    end

    it "parses a string space-separated format" do
      str = <<EOS
A B C
B C D
EOS
      @dep.parse(str)
      @dep.direct_dependencies_for('A').should eq %w{ B C }
      @dep.direct_dependencies_for('B').should eq %w{ C D }
    end
  end
end