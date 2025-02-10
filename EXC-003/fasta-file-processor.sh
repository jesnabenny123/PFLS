if [ $# -ne 1 ]; then
    echo "Usage: $0 <fasta_file>"
    exit 1
fi

FASTA_FILE="$1"

num_sequences=$(grep -c "^>" "$FASTA_FILE")

seq_lengths=$(awk '/^>/ {if (seqlen) print seqlen; seqlen=0; next} {seqlen += length} END {print seqlen}' "$FASTA_FILE")

total_length=$(echo "$seq_lengths" | awk '{sum+=$1} END {print sum}')

longest_seq=$(echo "$seq_lengths" | sort -nr | head -1)

shortest_seq=$(echo "$seq_lengths" | sort -n | head -1)

average_length=$(echo "scale=2; $total_length / $num_sequences" | bc)

gc_content=$(awk '/^>/ {next} {gc+=gsub(/[GgCc]/,""); total+=length} END {if (total > 0) print (gc/total)*100}' "$FASTA_FILE")


echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: $num_sequences"
echo "Total length of sequences: $total_length"
echo "Length of the longest sequence: $longest_seq"
echo "Length of the shortest sequence: $shortest_seq"
echo "Average sequence length: $average_length"
echo "GC Content (%): $gc_content"