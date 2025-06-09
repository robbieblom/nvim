def generate_fibonacci(n):
    """
    Generate the Fibonacci sequence up to the nth number.

    Args:
        n (int): The number of terms in the Fibonacci sequence to generate.

    Returns:
        list: A list containing the Fibonacci sequence.
    """
    if n <= 0:
        return []
    elif n == 1:
        return [0]
    elif n == 2:
        return [0, 1]

    sequence = [0, 1]
    for _ in range(2, n):
        sequence.append(sequence[-1] + sequence[-2])
    return sequence


if __name__ == "__main__":
    # Example usage
    num_terms = 10
    print(f"Fibonacci sequence up to {num_terms} terms: {generate_fibonacci(num_terms)}")
