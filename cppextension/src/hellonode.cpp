#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/godot.hpp>

using namespace godot;

class HelloNode : public Node {
    GDCLASS(HelloNode, Node)

protected:
    // Add this protected section with the required _bind_methods function
    static void _bind_methods() {
        // Empty for now - will be used to register methods, properties, and signals
    }

public:
    void _ready() {
        // Initialization code here
        UtilityFunctions::print("Hello from C++!");
    }
};

