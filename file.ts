export async function GET(request: NextRequest) {
  await auth.protect();
  const btibe = new BTIBackendClient({ type: "api-rls" });
  await btibe.connect({ txn: true });
  try {
    return new Response(JSON.stringify({}), {
      headers: {
        "content-type": "application/json",
      },
    });
  } catch (error) {
    console.error("Error with GET test:", error);
    return new Response("Failed GET test", { status: 500 });
  } finally {
    await btibe.end();
  }
}
