import "package:flutter/material.dart";
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentSheet extends StatefulWidget {
  final String dishName;
  final String dishId;
  const CommentSheet({super.key, required this.dishName, required this.dishId});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> Allcomments = [];
  final user = Supabase.instance.client.auth.currentUser;
  bool _loading = true;
  Future<void> _getComments() async {
    try {
      final response = await Supabase.instance.client
          .from('comments')
          .select('content')
          .eq('dish_id', widget.dishId);

      // Map to a list of comment + username strings or a structured model
      setState(() {
        Allcomments = List<Map<String, dynamic>>.from(response);
        _loading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleCommentSubmit() async {
    try {
      final response = await Supabase.instance.client.from('comments').insert({
        'dish_id': widget.dishId,
        'content': _controller.text,
        'user_id': Supabase.instance.client.auth.currentUser?.id,
      });
      setState(() {
        Allcomments.add({"content": _controller.text});
        _controller.clear();
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getComments();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                'Commentaires  (${Allcomments.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child:
                    Allcomments.isEmpty
                        ? const Center(
                          child: Text('Aucun commentaire pour le moment.'),
                        )
                        : ListView.builder(
                          controller: scrollController,
                          itemCount: Allcomments.length,
                          itemBuilder:
                              (context, index) => ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(
                                  "ACHRAF",
                                  style: TextStyle(color: Colors.black87),
                                ),
                                subtitle: Text(Allcomments[index]["content"] ,
                                style: TextStyle(color: Colors.black87),),
                              ),
                        ),
              ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Ajouter un commentaire...",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _handleCommentSubmit,
                  ),
                ),
                onSubmitted: (_) => _handleCommentSubmit(),
              ),
            ],
          ),
        );
      },
    );
  }
}
